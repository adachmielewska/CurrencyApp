//
//  MockWebRepository.swift
//  CurrencyAppTests
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import XCTest
@testable import CurrencyApp
import Combine

final class MockWebRepository: WebRepository {
    var hostUrl = URL(string: "https://test.com")!
    private(set) var sentRequests = [URLRequestElement]()

    var value: Decodable?
    var data: Data?
    var error: Error?

    func call<Value: Decodable>(endpoint: URLRequestElement) -> AnyPublisher<Value, Error> {
        sentRequests.append(endpoint)
        return Future<Value, Error> { [self] promise in
            if let value = self.value {
                promise(.success(value as! Value))
            } else if let error = self.error {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

}
