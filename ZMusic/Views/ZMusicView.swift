//
//  ContentView.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI

struct ZMusicView: View {
    var body: some View {
        TabView {
            YourTracksView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Home")
                }
            StreamPlayerView()
                .tabItem {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("Radio")
                    
                }
            RecentView()
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
