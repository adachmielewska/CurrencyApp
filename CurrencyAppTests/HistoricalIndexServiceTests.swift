//
//  HistoricalIndexServiceTests.swift
//  CurrencyAppTests
//
//  Created by Adriana Chmielewska on 27/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import XCTest
@testable import CurrencyApp
import Combine

final class HistoricalIndexServiceTests: XCTestCase {
    private var sut: HistoricalIndexService!
    private var cancelBag = CancelBag()

    override func setUpWithError() throws {
        RequestMocking.removeAllMocks()
        sut = RealHistoricalIndexService(webRepository: RealWebRepository(session: URLSession.mockedResponses, baseURL: URL(string: "https://test.com")!, authorizer: nil))
    }

    func test_givenEndpoint_whenFetchCurrentIndex_thenReturnDataSuccesful() {
        RequestMocking.add(mock: .historicalIndex())
        let data = BindingWithPublisher(value: Loadable<[HistoricalPresentationModel]>.notRequested)
        sut.fetchIndex(data: data.binding)

        let expected: [HistoricalPresentationModel] = [HistoricalPresentationModel(date: "2013-09-05", price: "120.5333$"), HistoricalPresentationModel(date: "2013-09-04", price: "120.5738$"), HistoricalPresentationModel(date: "2013-09-03", price: "127.5915$"), HistoricalPresentationModel(date: "2013-09-02", price: "127.3648$"), HistoricalPresentationModel(date: "2013-09-01", price: "128.2597$")]
        let exp = XCTestExpectation(description: #function)
        data.updatesRecorder.sink { updates in
            XCTAssertEqual(updates, [
               .notRequested,
               .isLoading(last: nil, cancelBag: CancelBag()),
               .loaded(expected)
            ])
            exp.fulfill()
        }.store(in: cancelBag)

        wait(for: [exp], timeout: 2)
    }

    func test_givenEndpointFailed_whenFetchCurrentIndex_thenReturnError() {
        RequestMocking.add(mock: .historicalIndexFailed())
        let data = BindingWithPublisher(value: Loadable<[HistoricalPresentationModel]>.notRequested)
        sut.fetchIndex(data: data.binding)

        let exp = XCTestExpectation(description: #function)
        data.updatesRecorder.sink { updates in
            XCTAssertEqual(updates, [
               .notRequested,
               .isLoading(last: nil, cancelBag: CancelBag()),
               .failed(NetworkError.unknown)
            ])
            exp.fulfill()
        }.store(in: cancelBag)

        wait(for: [exp], timeout: 2)
    }
}

extension MockedResponse {
    static func historicalIndex() -> MockedResponse {
        return RequestMocking.successfulResponse(enpoint: BPIEndpoints.historicalIndex(startDate: "2021-06-24", endDate: "2021-06-11"), response: "HistoricalIndex")
    }

    static func historicalIndexFailed() -> MockedResponse {
        return RequestMocking.failedResponse(enpoint: BPIEndpoints.historicalIndex(startDate: "2021-06-24", endDate: "2021-06-11"), response: nil)
    }
}
