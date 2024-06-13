//
//  AudioPlayerViewModel.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTrack: AudioTrack?
    private var audioPlayer: AVAudioPlayer?
    private var trackList: [AudioTrack]
    private var currentTrackIndex = 0

    init(trackList: [AudioTrack]) {
        self.trackList = trackList
        prepareTrack()
    }

    private func prepareTrack() {
        guard trackList.indices.contains(currentTrackIndex) else { return }
        let track = trackList[currentTrackIndex]
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: track.url)
            audioPlayer?.prepareToPlay()
            currentTrack = track
        } catch {
            print("Error loading track: \(error)")
        }
    }

    func playPause() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func nextTrack() {
        currentTrackIndex = (currentTrackIndex + 1) % trackList.count
        prepareTrack()
        playPause() // Start playing the new track
    }

    func previousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + trackList.count) % trackList.count
        prepareTrack()
        playPause() // Start playing the new track
    }

    func fastForward() {
        guard let player = audioPlayer else { return }
        player.currentTime += 10
    }

    func rewind() {
        guard let player = audioPlayer else { return }
        player.currentTime -= 10
    }
}
