//
//  ContentView.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI

struct MusicPlayerView: View {
    @StateObject private var viewModel: AudioPlayerViewModel
    

    init(tracks: [AudioTrack]) {
        _viewModel = StateObject(wrappedValue: AudioPlayerViewModel(trackList: tracks))
    }

    var body: some View {
        VStack {
            Text(viewModel.currentTrack?.title ?? "No Track")
                .font(.headline)
                .padding()

            HStack {
                Button(action: viewModel.previousTrack) {
                    Image(systemName: "backward.fill")
                }
                .padding()
                
                Button(action: viewModel.rewind) {
                    Image(systemName: "gobackward.10")
                }
                .padding()

                Button(action: viewModel.playPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                }
                .padding()

                Button(action: viewModel.fastForward) {
                    Image(systemName: "goforward.10")
                }
                .padding()
                
                Button(action: viewModel.nextTrack) {
                    Image(systemName: "forward.fill")
                }
                .padding()
            }
        }
        .padding()
    }
}

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTracks = [
            AudioTrack(title: "Три дня дождя - Отпускай", url: URL(fileURLWithPath: "/Users/annanikolaevna/Downloads/Три дня дождя - Отпускай.mp3")),
            AudioTrack(title: "Скриптонит,104 - Ты это серьёзно", url: URL(fileURLWithPath: "/Users/annanikolaevna/Downloads/Скриптонит,104 - Ты это серьёзно_.mp3"))
        ]
        MusicPlayerView(tracks: sampleTracks)
    }
}

