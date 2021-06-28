//
//  CurrentIndexTests.swift
//  CurrencyAppTests
//
//  Created by Adriana Chmielewska on 26/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import XCTest
@testable import CurrencyApp
import Combine

final class CurrentIndexServiceTests: XCTestCase {
    private var sut: CurrentIndexService!
    private var cancelBag = CancelBag()

    override func setUpWithError() throws {
        RequestMocking.removeAllMocks()
        sut = RealCurrentIndexService(webRepository: RealWebRepository(session: URLSession.mockedResponses, baseURL: URL(string: "https://test.com")!, authorizer: nil))
    }

    func test_givenEndpoint_whenFetchCurrentIndex_thenReturnDataSuccesful() {
        RequestMocking.add(mock: .currentIndex())
        let data = BindingWithPublisher(value: Loadable<CurrentIndexPresentationModel>.notRequested)
        sut.fetchCurrent(data: data.binding)

        let expected = CurrentIndexPresentationModel(prices: [CurrencyApp.CurrentCurrencyIndexPresentationModel(description: "United States Dollar", price: "126.5235$"), CurrencyApp.CurrentCurrencyIndexPresentationModel(description: "British Pound Sterling", price: "79.2495£"), CurrencyApp.CurrentCurrencyIndexPresentationModel(description: "Euro", price: "94.7398€")])
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

    func test_givenEndpointReturnError_whenFetchCurrentIndex_thenFailed() {
        RequestMocking.add(mock: .currentIndexFailed())
        let data = BindingWithPublisher(value: Loadable<CurrentIndexPresentationModel>.notRequested)
        sut.fetchCurrent(data: data.binding)

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
    static func currentIndex() -> MockedResponse {
        return RequestMocking.successfulResponse(enpoint: BPIEndpoints.currentIndex, response: "CurrentIndex")
    }

    static func currentIndexFailed() -> MockedResponse {
        return RequestMocking.failedResponse(enpoint: BPIEndpoints.currentIndex, response: nil)
    }
}
