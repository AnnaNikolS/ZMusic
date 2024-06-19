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
    @Published var currentIndex: Int?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    
    var currentTrack: Track? {
        guard let currentIndex = currentIndex, tracks.indices.contains(currentIndex) else {
            return nil
        }
        return tracks[currentIndex]
    }
    
    // MARK: - Methods
    func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "00:00" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func playAudio(track: Track) {
        do {
            self.player = try AVAudioPlayer(data: track.data)
            self.player?.play()
            totalTime = player?.duration ?? 0.0
            isPlaying.toggle()
            if let index = tracks.firstIndex(where: { $0.id == track.id }) {
                currentIndex = index
            }
        } catch {
            print("Error in audio playback: \(error.localizedDescription)")
        }
    }
    
    func seekAudio(time: TimeInterval) {
        player?.currentTime = time
    }
    
    func update() {
        guard let player = player else { return }
        currentTime = player.currentTime
    }
    
    func playPause() {
        if isPlaying {
            self.player?.pause()
        } else {
            self.player?.play()
        }
        isPlaying.toggle()
    }
}
