//
//  DIContainer.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 31/05/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct DIContainer {
    let appState: Store<AppState>
    let services: Services

    init(appState: Store<AppState>, services: DIContainer.Services) {
        self.appState = appState
        self.services = services
    }

    init(appState: AppState, services: DIContainer.Services) {
        self.init(appState: Store(appState), services: services)
    }
}

extension DIContainer {
    struct Services {
        let currentIndexService: CurrentIndexService
        let historicalIndexesService: HistoricalIndexService
    }
}
