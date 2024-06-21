//
//  ContentView.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI

struct ZMusicView: View {
    
    //MARK: - Properties
    @StateObject var viewModel = RecentViewModel()
    
    var body: some View {
        TabView {
            YourTracksView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Home")
                }
            RadioPlayerView()
                .tabItem {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("Radio")
                }
            RecentView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Recent")
                }
        }
        .customizeTabBar()
    }
}

#Preview {
    ZMusicView()
}
