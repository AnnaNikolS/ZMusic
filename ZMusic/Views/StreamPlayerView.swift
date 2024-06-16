//
//  StreamPlayerView.swift
//  ZMusic
//
//  Created by Анна on 16.06.2024.
//

import SwiftUI

struct StreamPlayerView: View {
    @StateObject private var viewModel = StreamPlayerViewModel()
    @State private var streamURL = URL(string: "https://ep256.hostingradio.ru:8052/europaplus256.mp3")!

    var body: some View {
        VStack {
            Button(action: {
                if viewModel.isPlaying {
                    viewModel.stopStream()
                } else {
                    viewModel.playStream(from: streamURL)
                }
            }) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
            }
            .padding()
        }
    }
}

struct StreamPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        StreamPlayerView()
    }
}
