//
//  ErrorView.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 05/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        VStack {
            Text(Strings.Error.commonError)
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
        }
    }
}
