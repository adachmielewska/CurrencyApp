//
//  CurrentIndex.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 25/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation

struct CurrentIndex: Codable {
    let bpi: BPI
}

struct BPI: Codable {
    let usd: Currency
    let gbp: Currency
    let eur: Currency

    private enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

struct Currency: Codable {
    let code: String
    let symbol: String
    let rate: String
    let description: String
}

extension CurrentIndexPresentationModel {
    static func fromDataModel(_ item: BPI?) -> Self {
        let prices = [CurrentCurrencyIndexPresentationModel(description: item?.usd.description ?? "", price: "\(item?.usd.rate ?? "")$"),
                      CurrentCurrencyIndexPresentationModel(description: item?.gbp.description ?? "", price: "\(item?.gbp.rate ?? "")£"),
                      CurrentCurrencyIndexPresentationModel(description: item?.eur.description ?? "", price: "\(item?.eur.rate ?? "")€")]

        return CurrentIndexPresentationModel(prices: prices)
    }
}
