//
//  URLSession+Configuration.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation

extension URLSession {
    static var mockedResponses: URLSession {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [RequestMocking.self]
        configuration.timeoutIntervalForRequest = 30
        return URLSession(configuration: configuration)
    }

    static var urlSession: URLSession {
        let configuration = URLSessionConfiguration.af.default
          configuration.timeoutIntervalForRequest = 120
          return URLSession(configuration: configuration)
    }
}
