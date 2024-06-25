//
//  RecentView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI
import RealmSwift

struct RecentView: View {
    
    //MARK: - Properties
    @ObservedObject var viewModel: RecentViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradientView(colors: [.purple, .cyan, .black], location: .bottomTrailing, endRadius: 500)
                
                VStack {
                    List(viewModel.recentlyPlayed) { track in
                        RecentTrackCellView(track: track, formatDuration: viewModel.formatDuration(_:))
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Recent Auditions")
            .customizeNavigationBar()
        }
    }
}



