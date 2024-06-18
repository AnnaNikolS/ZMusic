//
//  RadialGradientView.swift
//  ZMusic
//
//  Created by Анна on 16.06.2024.
//

import SwiftUI

struct RadialGradientView: View {
    let colors: [Color]
    let location: UnitPoint
    let endRadius: CGFloat
    
    var body: some View {
        RadialGradient(
            colors: colors,
            center: location,
            startRadius: 0,
            endRadius: endRadius
        )
        .ignoresSafeArea()
    }
}

#Preview {
    RadialGradientView(colors: [.red, .purple, .blue, .black], location: .bottomLeading, endRadius: 700)
}
