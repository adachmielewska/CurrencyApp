//
//  Assets.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 09/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import SwiftUI

struct Assets {
    struct Color {}
    struct Image {}
}

extension Assets.Color {
    static var background: Color { Color(#function) }
    static var secondaryBackground: Color { Color(#function) }
    static var shadow: Color { Color(#function) }
}

extension Assets.Image {
    static var sun: Image { Image(#function) }
}
