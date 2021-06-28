//
//  LocationListView.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 05/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import SwiftUI
import Combine

struct BPIIndexListView: View {

    @ObservedObject private(set) var viewModel: ViewModel
    @State var isDetailsPresented: Bool = false
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    CurrentIndexView(viewModel: self.viewModel)
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            self.isDetailsPresented = true
                    }
                    .sheet(isPresented: self.$isDetailsPresented) {
                        CurrentIndexDetailsView(currentIndex: self.viewModel.currentIndex.value)
                    }
                    Text(Strings.HistoricalIndex.title)
                        .padding(.all, 8)
                        .padding(.top, 8)
                    HistoricalIndexesList(viewModel: self.viewModel)
                        .padding(.horizontal, 8)
                }.frame(maxWidth: .infinity)
                .onReceive(timer) {_ in
                    self.viewModel.refresh()
                }
            }.navigationBarTitle(Strings.CurrentIndex.bpiIndexNavigationTitle, displayMode: .automatic)
        }
    }
}

extension BPIIndexListView {
    struct Routing: Equatable {
        static func == (lhs: BPIIndexListView.Routing, rhs: BPIIndexListView.Routing) -> Bool {
            return true
        }

        var currentIndexDetails: CurrentIndexPresentationModel?
    }
}

extension BPIIndexListView {
    class ViewModel: ObservableObject {
        @Published var routingState: Routing
        @Published var currentIndex: Loadable<CurrentIndexPresentationModel> = .notRequested
        @Published var historicalIndexes: Loadable<[HistoricalPresentationModel]> = .notRequested
        @Published var selectedIndex: CurrentIndexPresentationModel?

        let container: DIContainer
        private var cancelBag = CancelBag()

        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.bpiIndexList)

            cancelBag.collect {
                $routingState
                    .sink { appState[\.routing.bpiIndexList] = $0 }
                appState.map(\.routing.bpiIndexList)
                    .removeDuplicates()
                    .assign(to: \.routingState, on: self)
            }
            getCurrentIndex()
            getHistoricalIndexes()
        }

        func refresh() {
            getCurrentIndex()
        }

        private func getCurrentIndex() {
            container.services.currentIndexService.fetchCurrent(data: loadableSubject(\.currentIndex))
        }

        private func getHistoricalIndexes() {
            container.services.historicalIndexesService.fetchIndex(data: loadableSubject(\.historicalIndexes))
        }
    }
}
