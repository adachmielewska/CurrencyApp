//
//  TestHelpers.swift
//  CurrencyAppTests
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import XCTest
import Combine
import SwiftUI
@testable import CurrencyApp

extension Result where Success: Equatable {
    func assertSuccess(value: Success, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            XCTAssertEqual(resultValue, value, file: file, line: line)
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}

extension Result where Success == Void {
    func assertSuccess(file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        case .success:
            break
        }
    }
}

extension Result {
    func assertFailure(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(value):
            XCTFail("Unexpected success: \(value)", file: file, line: line)
        case let .failure(error):
            if let message = message {
                XCTAssertEqual(error.localizedDescription, message, file: file, line: line)
            }
        }
    }
}

// MARK: - BindingWithPublisher

struct BindingWithPublisher<Value> {

    let binding: Binding<Value>
    let updatesRecorder: AnyPublisher<[Value], Never>

    init(value: Value, recordingTimeInterval: TimeInterval = 0.5) {
        var value = value
        var updates = [value]
        binding = Binding<Value>(
            get: { value },
            set: { value = $0; updates.append($0) })
        updatesRecorder = Future<[Value], Never> { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + recordingTimeInterval) {
                completion(.success(updates))
            }
        }.eraseToAnyPublisher()
    }
}

extension RequestMocking {
    static func failedResponse(enpoint: URLRequestElement,
                                   response fileName: String?,
                                   fileExtenstion: String = "json") -> MockedResponse {
        let path = URL(string: "https://test.com/")!
        let fullUrl = try! enpoint.createUrlRequest(baseUrl: path).url!
        let response = HTTPURLResponse(url: fullUrl, statusCode: 500, httpVersion: nil, headerFields: nil)!
        return MockedResponse(result: .failure(NetworkError.unknown), customResponse: response, loadingTime: 0)
    }
}
