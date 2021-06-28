//
//  AppState.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 31/05/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting()
}

extension AppState {
    static func valueForAPIKey(keyname: String) throws -> String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType:"plist") else { throw AnyError.init(debugMessage: "missing key") }
        let plist = NSDictionary(contentsOfFile:filePath)
        let value: String = (plist?.object(forKey: keyname)) as? String ?? ""

        return value
    }
}

extension AppState {
    struct UserData: Equatable {

    }
}

extension AppState {
    struct ViewRouting: Equatable {
        var bpiIndexList = BPIIndexListView.Routing()
        var locationDetails = CurrentIndexDetailsView.Routing()
    }
}
