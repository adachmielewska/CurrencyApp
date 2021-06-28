//
//  CurrentIndexView.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 27/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import SwiftUI

struct CurrentIndexView: View {
    @ObservedObject private(set) var viewModel: BPIIndexListView.ViewModel

    var body: some View {
        content
    }
}

extension CurrentIndexView: LoadableView {
    typealias Result = CurrentIndexPresentationModel

    internal var content: AnyView {
        switch viewModel.currentIndex {
        case .notRequested: return notRequestedView()
        case let .isLoading(last, cancelBag: _): return loadingView(last)
        case let .failed(error): return failedView(error)
        case let .loaded(data): return loadedView(data)
        }
    }

    func notRequestedView() -> AnyView {
        Text("").anyView()
    }

    func loadingView(_ previouslyLoaded: CurrentIndexPresentationModel?) -> AnyView {
        if let locations = previouslyLoaded {
            return AnyView(loadedView(locations))
        } else {
            return AnyView(ActivityIndicatorView().padding())
        }
    }

    func failedView(_ error: Error) -> AnyView {
        ErrorView(error: error).anyView()
    }

    func loadedView(_ result: CurrentIndexPresentationModel) -> AnyView {
        HStack() {
            VStack(alignment: .leading, spacing: 5) {
                Text(result.title)
                    .font(.largeTitle)
                Text(result.prices[0].price)
                    .font(.title)
                    .fontWeight(.light)
                Text(result.description)
                    .fontWeight(.light)
                Text(result.legalNote)
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
            }.padding(.all, 24)
            Spacer()
            }
        .background(Assets.Color.background)
        .cornerRadius(8)
        .shadow(color: Assets.Color.shadow, radius: 3, y: 8)
        .anyView()
    }
}
