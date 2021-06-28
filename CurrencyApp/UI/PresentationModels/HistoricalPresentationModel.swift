//
//  HistoricalPresentationModel.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 25/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import SwiftUI

struct HistoricalPresentationModel: Equatable {
    let date: String
    let price: String
}

extension HistoricalPresentationModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}

extension HistoricalPresentationModel: Identifiable {
    var id: String { UUID().uuidString }
}
