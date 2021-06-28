//
//  URLRequestElement.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
protocol URLRequestElement {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var parametersEncoding: ParameterEncoding { get }
    var headers: [String: String] { get }
}

extension URLRequestElement {
    func createUrlRequest(baseUrl: URL) throws -> URLRequest {
        var urlRequest = URLRequest(url: baseUrl.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return try parametersEncoding.encode(urlRequest, with: parameters)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
