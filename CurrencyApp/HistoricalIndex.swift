//
//  HistoricalIndex.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 26/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation

struct HistoricalIndex: Codable {
    let bpi: DatesIndex
}

struct DatesIndex: Codable {

    var indexes: [String: Double] = [:]

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
          init?(stringValue: String) {
              self.stringValue = stringValue
          }

        var intValue: Int?
        init?(intValue: Int) {
            nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in container.allKeys {
            guard let dynamicKey = DynamicCodingKeys(stringValue: key.stringValue) else {
                throw NetworkError.unknown
            }
            let decodedObject = try container.decode(Double.self, forKey: dynamicKey)
            indexes[key.stringValue] = decodedObject
        }
    }
}

extension HistoricalPresentationModel {
    static func fromPresentationModel(item: HistoricalIndex?) -> [Self] {
        item?.bpi.indexes.map {
            HistoricalPresentationModel(date: $0.key, price: "\($0.value)$")
        }.sorted { $0.date > $1.date } ?? []
    }
}
