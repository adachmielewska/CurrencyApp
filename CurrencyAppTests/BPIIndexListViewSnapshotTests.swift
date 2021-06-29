//
//  BPIIndexListViewSnapshotTests.swift
//  CurrencyAppTests
//
//  Created by Adriana Chmielewska on 29/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import XCTest
import SnapshotTesting
import SwiftUI
@testable import CurrencyApp

class BPIIndexListViewSnapshotTests: XCTestCase {

    var vm: BPIIndexListView.ViewModel!
    var sut: BPIIndexListView!

    override func setUp() {
        vm = .init(container: .preview)
        sut = BPIIndexListView(viewModel: vm)
    }

    func test_givenDataNotRequested_thenNotRequestedStateVisible() {
        vm.currentIndex = .notRequested
        vm.historicalIndexes = .notRequested
        assestSnapshotOnView()
    }

    func test_givenDataIsLoading_thenLoadingStateVisible() {
        vm.currentIndex = .isLoading(last: nil, cancelBag: CancelBag())
        vm.historicalIndexes = .isLoading(last: nil, cancelBag: CancelBag())
        assestSnapshotOnView()
    }

    func test_givenDataIsLoaded_thenLoadedIsStateVisible() {

        vm.currentIndex = .loaded(CurrentIndexPresentationModel(prices: [CurrentCurrencyIndexPresentationModel(description: "Dolar", price: "2133$")]))
        vm.historicalIndexes = .loaded([HistoricalPresentationModel(date: "20-06-2021", price: "2333$"), HistoricalPresentationModel(date: "19-06-2021", price: "45555$"), HistoricalPresentationModel(date: "18-06-2021", price: "79999$")])
        assestSnapshotOnView()
    }

    private func assestSnapshotOnView(testName: String = #function) {
        let sut = BPIIndexListView(viewModel: vm)
        assertSnapshot(matching: sut.toVC(), as: .image, testName: testName)
    }
}

extension SwiftUI.View {
    func toVC() -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.frame = UIScreen.main.bounds
        return vc
    }
}
