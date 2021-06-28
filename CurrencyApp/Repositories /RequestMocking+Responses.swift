//
//  RequestMocking+Responses.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation

extension RequestMocking {
    static var mocks: [MockedResponse] = {
        return []
    }()

    enum Endpoint {}

    static func successfulResponse(enpoint: URLRequestElement,
                                   response fileName: String?,
                                   fileExtenstion: String = "json") -> MockedResponse {
        guard let path = URL(string: "https://test.com/"),
            let fullUrl = try? enpoint.createUrlRequest(baseUrl: path).url,
            let response = HTTPURLResponse(url: fullUrl, statusCode: 200, httpVersion: nil, headerFields: nil),
            let mock = try? MockedResponse(result: .success(MockedResponse.data(fromFileNamed: fileName, fileExtension: fileExtenstion)), customResponse: response, loadingTime: 0) else {
            return MockedResponse(result: .failure(ValueIsMissingError()), customResponse: URLResponse(), loadingTime: 0)
        }
        return mock
    }
}
