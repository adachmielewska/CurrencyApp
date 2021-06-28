//
//  Strings.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 27/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import SwiftUI

struct Strings {
    struct Error {
        static var commonError: LocalizedStringKey {
            "error.commonError"
        }
    }

    struct CurrentIndex {
        static var bpiIndexNavigationTitle: LocalizedStringKey {
            "navigationTitle.bpiIndex"
        }

        static var title: LocalizedStringKey {
            "currentIndex.title"
        }

        static var description: LocalizedStringKey {
            "currentIndex.description"
        }

        static var legalNote: LocalizedStringKey {
            "currentIndex.note"
        }

        struct Details {
            static var detailsNavigationTitle: LocalizedStringKey {
                "navigationTitle.curentRates"
            }

            static var dismissButtonTitle: LocalizedStringKey {
                "currentIndex.dismiss"
            }

            static var empty: LocalizedStringKey {
                "currentIndex.empty"
            }


        }
    }

    struct HistoricalIndex {
        static var title: LocalizedStringKey {
            "historical.title"
        }
    }

    struct ProcessInfo {
        static var testConfig: String {
            "XCTestConfigurationFilePath"
        }
    }
}
