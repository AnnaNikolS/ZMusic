//
//  AudioPlayerViewModel.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI
import AVFAudio
import RealmSwift

class YourTracksViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    //MARK: - Properties
    @Published var tracks: [Track] = []
    @Published var player: AVAudioPlayer?
    @Published var currentIndex: Int?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    @Published var recentlyPlayed: [RecentTrack] = []
    
    //MARK: - Private Properties
    private var repository: RealmTrackRepository
    private var notificationToken: NotificationToken?
    
    // MARK: - Initializer
    override init() {
        self.repository = RealmTrackRepository.shared
        super.init()
        loadTracksFromRealm()
        observeRecentlyPlayed()
    }
    
    //MARK: - Getters
    var currentTrack: Track? {
        guard let currentIndex = currentIndex, tracks.indices.contains(currentIndex) else {
            return nil
        }
        return tracks[currentIndex]
    }
    
    //MARK: - Realm Methods
    // loading realm tracks
    private func loadTracksFromRealm() {
        self.tracks = repository.fetchAllTracks().map { recentTrack in
            Track(
                id: recentTrack.id,
                name: recentTrack.name,
                data: recentTrack.data,
                artist: recentTrack.artist,
                duration: recentTrack.duration,
                image: recentTrack.image
            )
        }
    }
    
    private func observeRecentlyPlayed() {
        repository.$recentlyPlayedTracks
            .receive(on: DispatchQueue.main)
            .assign(to: &$recentlyPlayed)
    }
    
    func addTrack(track: Track) {
        repository.saveTrack(track: track)
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
            self.player?.delegate = self
            self.player?.play()
            totalTime = player?.duration ?? 0.0
            isPlaying.toggle()
            if let index = tracks.firstIndex(where: { $0.id == track.id }) {
                currentIndex = index
            }
            repository.saveTrack(track: track) // save in realm
        } catch {
            print("Error in audio playback: \(error.localizedDescription)")
        }
    }
    
    func delete(offsets: IndexSet) {
        if let first = offsets.first {
            stopAudio()
            let track = tracks[first]
            tracks.remove(at: first)
            repository.deleteTrack(id: track.id) // delete in realm
        }
    }
    
    func stopAudio() {
        self.player?.stop()
        self.player = nil
        isPlaying = false
    }
    
    func forward() {
        guard let currentIndex = currentIndex else { return }
        let nextIndex = currentIndex + 1 < tracks.count ? currentIndex + 1 : 0
        playAudio(track: tracks[nextIndex])
        isPlaying = true
    }
    
    func backward() {
        guard let currentIndex = currentIndex else { return }
        let previousIndex = currentIndex > 0 ? currentIndex - 1 : tracks.count - 1
        playAudio(track: tracks[previousIndex])
        isPlaying = true
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            forward()
        }
    }
}
