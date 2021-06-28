//
//  ParameterEncoding.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 01/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import Alamofire

protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest
}

struct URLEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String : Any]?) throws -> URLRequest {
        return try Alamofire.URLEncoding().encode(urlRequest, with: parameters)
    }
}

struct JSONEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String : Any]?) throws -> URLRequest {
        return try Alamofire.JSONEncoding().encode(urlRequest, with: parameters)
    }
}
