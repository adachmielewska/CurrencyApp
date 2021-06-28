//
//  Helpers.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 28/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation

extension ProcessInfo {
    static var isRunningTests: Bool {
        processInfo.environment[Strings.ProcessInfo.testConfig] != nil
    }
}

extension Date {
    static var currentDate: Date {
        guard !ProcessInfo.isRunningTests else {
            let componets = DateComponents(year: 2021, month: 6, day: 25)
            return Calendar.current.date(from: componets) ?? Date()
        }
        return Date()
    }
}
