//
//  ContentView.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI

struct ZMusicView: View {
    
    //MARK: - Properties
    @StateObject var recentViewModel = RecentViewModel()
    @StateObject var radioCardViewModel = RadioCardViewModel()
    @StateObject var yourTracksViewModel = YourTracksViewModel()
    
    var body: some View {
        TabView {
            YourTracksView(viewModel: yourTracksViewModel)
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Home")
                }
            RadioPlayerView(viewModel: radioCardViewModel)
                .tabItem {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("Radio")
                }
            RecentView(viewModel: recentViewModel)
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
