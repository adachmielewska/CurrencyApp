//
//  CurrentIndexPresentationModel.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 25/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import SwiftUI

struct CurrentIndexPresentationModel: Equatable {
    let title = Strings.CurrentIndex.title
    let prices: [CurrentCurrencyIndexPresentationModel]
    let description = Strings.CurrentIndex.description
    let legalNote = Strings.CurrentIndex.legalNote
}

extension CurrentIndexPresentationModel: Identifiable {
    var id: String { UUID().uuidString }
}

struct CurrentCurrencyIndexPresentationModel: Equatable {
    let description: String
    let price: String
}

extension CurrentCurrencyIndexPresentationModel: Identifiable {
    var id: String { UUID().uuidString }
}
