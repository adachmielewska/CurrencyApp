//
//  AppEnviroment.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 31/05/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {

    static func bootstrap() throws -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        let webRepositories = try configuredWebRepositories()
        let services = configuredServices(appState: appState,
                                                webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, services: services)
        return AppEnvironment(container: diContainer)
    }

    private static func configuredWebRepositories() throws -> DIContainer.WebRepositories {
        guard let baseURL = URL(string: try AppState.valueForAPIKey(keyname: "BaseURL")) else { throw NetworkError.invalidURL }
        return .init(defaultWebRepository: RealWebRepository(session: URLSession.urlSession,
                                                             baseURL: baseURL,
                                                             authorizer: nil))
    }

    private static func configuredServices(appState: Store<AppState>,
                                           webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Services {
        return .init(currentIndexService: RealCurrentIndexService(webRepository: webRepositories.defaultWebRepository),
                     historicalIndexesService: RealHistoricalIndexService(webRepository: webRepositories.defaultWebRepository))
    }
}

extension DIContainer {
    struct WebRepositories {
        let defaultWebRepository: WebRepository
    }
}
