//
//  WebRepositoryTests.swift
//  CurrencyAppTests
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import XCTest
@testable import CurrencyApp
import Combine

final class WebRepositoryTests: XCTestCase {
    private var sut: MockWebRepository!
    private var cancelBag = CancelBag()

    override func setUp() {
        sut = MockWebRepository()
    }

    func test_givenEndpoint_whenCalled_thenSuccess() {
        let endpoint = TestEndpoint.test
        sut.value = TestData()
        let exp = XCTestExpectation(description: #function)
        let load: AnyPublisher<TestData, Error> = sut.call(endpoint: endpoint)
        load.sinkToResult { result in
            result.assertSuccess(value: TestData())
            exp.fulfill()
        }.store(in: cancelBag)

        wait(for: [exp], timeout: 2)
    }

    func test_givenEndpoint_whenCalled_thenHttpCodeFailure() {
        let endpoint = TestEndpoint.test
        sut.error = NetworkError.errorStatusCode(code: 400)
        let exp = XCTestExpectation(description: #function)
        let load: AnyPublisher<TestData, Error> = sut.call(endpoint: endpoint)
        load.sinkToResult { result in
            result.assertFailure(NetworkError.errorStatusCode(code: 400).localizedDescription)
            exp.fulfill()
        }.store(in: cancelBag)

        wait(for: [exp], timeout: 2)
    }

    func test_givenEndpoint_whenCalled_thenUnknownError() {
        let endpoint = TestEndpoint.test
        sut.error = NetworkError.unknown
        let exp = XCTestExpectation(description: #function)
        let load: AnyPublisher<TestData, Error> = sut.call(endpoint: endpoint)
        load.sinkToResult { result in
            result.assertFailure(NetworkError.unknown.localizedDescription)
            exp.fulfill()
        }.store(in: cancelBag)

        wait(for: [exp], timeout: 2)
    }

    func test_givenEndpoint_whenCalled_thenInvalidUrl() {
        let endpoint = TestEndpoint.urlError
        sut.error = NetworkError.invalidURL
        let exp = XCTestExpectation(description: #function)
        let load: AnyPublisher<TestData, Error> = sut.call(endpoint: endpoint)
        load.sinkToResult { result in
            result.assertFailure(NetworkError.invalidURL.localizedDescription)
            exp.fulfill()
        }.store(in: cancelBag)

        wait(for: [exp], timeout: 2)
    }

    func test_givenElements_whenCreatedURLRequest_thenPropoerValues() {
        let endpoint = TestEndpoint.test
        let request = try! endpoint.createUrlRequest(baseUrl: sut.hostUrl)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://test.com/test?parameter1=value1&parameter2=value2"))
        XCTAssertEqual(request.httpBody, nil)
    }

    func test_givenPostElements_whenCreatedURLRequest_thenProperValues() {
        let endpoint = TestEndpoint.jsonEncoding
        let request = try! endpoint.createUrlRequest(baseUrl: sut.hostUrl)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url, URL(string: "https://test.com/test"))
        XCTAssertNotNil(request.httpBody)
        let param1 = "\"parameter1\":\"value1\""
        let param2 = "\"parameter2\":\"value2\""
        XCTAssertTrue(String(decoding: request.httpBody!, as: UTF8.self).contains(param1))
        XCTAssertTrue(String(decoding: request.httpBody!, as: UTF8.self).contains(param2))
    }
}
struct TestData: Codable, Equatable {
    let id: Int
    let value: String

    init(id: Int = 1, value: String = "Test value") {
        self.id = id
        self.value = value
    }
}

enum TestEndpoint: String, URLRequestElement {
    case test
    case jsonEncoding
    case urlError

    private var components: [String] {
        switch self {
        case .test, .jsonEncoding: return ["test"]
        case .urlError: return ["//error"]
        }
    }

    var path: String {
        return self.components.joined(separator: "/")
    }

    var method: HTTPMethod {
        switch self {
        case .test, .urlError:
            return .get
        case .jsonEncoding:
            return .post
        }
    }

    var headers: [String : String] {
        switch self {
        case .test: return ["key": "value"]
        default: return [:]
        }
    }

    var parameters: [String : Any] {
        switch self {
        default:
            return ["parameter1": "value1", "parameter2": "value2"]
        }
    }

    var parametersEncoding: ParameterEncoding {
        switch self {
        case .test, .urlError: return URLEncoding()
        case .jsonEncoding: return JSONEncoding()
        }
    }
}

