//
//  StreamPlayerViewModel.swift
//  ZMusic
//
//  Created by Анна on 16.06.2024.
//

import AVKit
import SwiftUI

class StreamPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    private var player: AVPlayer?

    func playStream(from url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
    }

    func stopStream() {
        player?.pause()
        isPlaying = false
    }
}

