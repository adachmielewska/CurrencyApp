//
//  CurrentIndexDetailsView.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 09/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import SwiftUI
import Combine

struct CurrentIndexDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    let currentIndex: CurrentIndexPresentationModel?
    
    var body: some View {
        NavigationView {
            content()
            .navigationBarTitle(Strings.CurrentIndex.Details.detailsNavigationTitle)
            .navigationBarItems(leading:
                Button(Strings.CurrentIndex.Details.dismissButtonTitle) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            ).navigationBarBackButtonHidden(true)
        }
    }

    func content() -> AnyView {
        guard let currentIndex = currentIndex else {
            return Text(Strings.CurrentIndex.Details.empty).anyView()
        }

        return List(currentIndex.prices) {
            CurrencyPriceCell(index: $0)
        }.anyView()
    }
}

struct CurrencyPriceCell: View {

    let index: CurrentCurrencyIndexPresentationModel

    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 5) {
                Text(index.description)
                Text(index.price)
            }.padding(.all, 24)
            Spacer()
        }
        .background(Assets.Color.background)
        .cornerRadius(8)
        .shadow(color: Assets.Color.shadow, radius: 3, y: 8)
    }
}

extension CurrentIndexDetailsView {
    struct Routing: Equatable {
    }
}

extension CurrentIndexDetailsView {
    class ViewModel: ObservableObject {
        @Published var routingState: Routing
        private var cancelBag = CancelBag()

        init(container: DIContainer) {
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.locationDetails)
                   cancelBag.collect {
                       $routingState
                           .sink { appState[\.routing.locationDetails] = $0 }
                       appState.map(\.routing.locationDetails)
                           .removeDuplicates()
                           .assign(to: \.routingState, on: self)
                   }
        }
    }
}
