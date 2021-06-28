//
//  CancelBag.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 31/05/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import Combine

final class CancelBag {
    var subscriptions = Set<AnyCancellable>()

    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }

    @_functionBuilder
    struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

extension AnyCancellable {

    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
