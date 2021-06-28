//
//  BPIEndpoints.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 25/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation

enum BPIEndpoints: URLRequestElement {
    case currentIndex
    case historicalIndex(startDate: String, endDate: String)

    var method: HTTPMethod {
        switch  self {
        case .currentIndex, .historicalIndex:
            return .get
        }
    }

    var path: String {
        switch  self {
        case .currentIndex:
            return "currentPrice.json"
        case .historicalIndex:
            return "historical/close.json"
        }
    }

    var parameters: [String : Any] {
        switch self {
        case .currentIndex:
            return [:]
        case let .historicalIndex(startDate, endDate):
            return ["start": "\(startDate)", "end": "\(endDate)"]
        }
    }

    var parametersEncoding: ParameterEncoding {
        return URLEncoding()
    }

    var headers: [String : String] {
        return [:]
    }
}
