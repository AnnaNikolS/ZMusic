//
//  AudioPlayerViewModel.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI
import AVFAudio

class YourTracksViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var player: AVAudioPlayer?
    @Published var currentTrack: Track?
    @Published var isPlaying = false
    
    // MARK: - Methods
    func playAudio(track: Track) {
        do {
            self.player = try AVAudioPlayer(data: track.data)
            self.player?.play()
            isPlaying = true
        } catch {
            print("Error in audio playback: \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        
    }
}
