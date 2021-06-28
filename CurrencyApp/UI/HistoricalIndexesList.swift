//
//  HistoricalIndexesList.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 27/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import SwiftUI

struct HistoricalIndexesList: View {
    @ObservedObject private(set) var viewModel: BPIIndexListView.ViewModel

    var body: some View {
        content
    }
}

extension HistoricalIndexesList: LoadableView {
    typealias Result = [HistoricalPresentationModel]

    internal var content: AnyView {
        switch viewModel.historicalIndexes {
        case .notRequested: return notRequestedView()
        case let .isLoading(last, cancelBag: _): return loadingView(last)
        case let .failed(error): return failedView(error)
        case let .loaded(data): return loadedView(data)
        }
    }

    func notRequestedView() -> AnyView {
        Text("").anyView()
    }

    func loadingView(_ previouslyLoaded: [HistoricalPresentationModel]?) -> AnyView {
        if let locations = previouslyLoaded {
            return AnyView(loadedView(locations))
        } else {
            return AnyView(ActivityIndicatorView().padding())
        }
    }

    func failedView(_ error: Error) -> AnyView {
        ErrorView(error: error).anyView()
    }

    func loadedView(_ result: [HistoricalPresentationModel]) -> AnyView {
        ForEach(result, id: \.self) {
            IndexCell(index: $0)
        }.anyView()
    }
}

struct IndexCell: View {

    let index: HistoricalPresentationModel

    var body: some View {
        HStack() {
            HStack() {
                Text(index.date)
                    .foregroundColor(Color.white)
                Spacer()
                Text(index.price)
                    .foregroundColor(Color.white)
            }.padding(.all, 24)
            Spacer()
        }
        .background(Assets.Color.secondaryBackground)
        .cornerRadius(8)
        .shadow(color: Assets.Color.shadow, radius: 3, y: 8)
    }
}
