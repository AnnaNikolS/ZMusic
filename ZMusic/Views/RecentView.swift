//
//  RecentView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI

struct RecentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradientView(colors: [.purple, .cyan, .black], location: .bottomTrailing, endRadius: 500)
            }
            .navigationTitle("Recent auditions")
            .customizeNavigationBar()
        }
    }
}

#Preview {
    RecentView()
}
