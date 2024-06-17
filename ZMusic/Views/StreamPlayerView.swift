//
//  StreamPlayerView.swift
//  ZMusic
//
//  Created by Анна on 16.06.2024.
//

import SwiftUI

struct StreamPlayerView: View {
    
    @StateObject var viewModel = RadioStationsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradientView(colors: [.white.opacity(0.7), .blue, .indigo, .black], location: .bottomLeading, endRadius: 450)
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.stations) { station in
                            StreamCardView(
                                title: station.title,
                                image: station.image,
                                isPlaying: viewModel.currentStation?.id == station.id
                            ) {
                                viewModel.playRadio(station: station)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Radio")
            .customizeNavigationBar()
        }
    }
}

struct StreamPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        StreamPlayerView()
    }
}
