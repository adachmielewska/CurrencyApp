//
//  RequestMocking.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation

struct MockedResponse {
    let result: Result<Data, Error>
    let customResponse: URLResponse
    let loadingTime: TimeInterval
}

extension MockedResponse {
    static func data(fromFileNamed fileName: String?, fileExtension: String) throws -> Data {
        guard let fileName = fileName else { return Data() }
        let data = Bundle.main
        .url(forResource: fileName, withExtension: fileExtension)
            .flatMap { try? Data(contentsOf: $0) }

        guard let response = data else {
            throw AnyError(debugMessage: "Cannot read file \(fileName)")
        }
        return response
    }
}

struct AnyError: Error {
    let debugMessage: String
}

extension RequestMocking {
    static func add(mock: MockedResponse) {
        mocks.append(mock)
    }

    static func removeAllMocks() {
        mocks.removeAll()
    }

    static private func mock(for request: URLRequest) -> MockedResponse? {
        return mocks.first { $0.customResponse.url == request.url }
    }
}

final class RequestMocking: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return mock(for: request) != nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    override func startLoading() {
        if let mock = RequestMocking.mock(for: request) {
            client?.urlProtocol(self, didReceive: mock.customResponse, cacheStoragePolicy: .notAllowed)
            DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
                guard let self = self else { return }
                switch mock.result {
                case let .success(data):
                    self.client?.urlProtocol(self, didLoad: data)
                    self.client?.urlProtocolDidFinishLoading(self)
                case let .failure(error):
                    let failure = NSError(domain: NSURLErrorDomain, code: 1, userInfo: [NSUnderlyingErrorKey: error])
                    self.client?.urlProtocol(self, didFailWithError: failure)
                }
            }
        }
    }

    override func stopLoading() { }
}
