//
//  RecentViewModel.swift
//  ZMusic
//
//  Created by Анна on 21.06.2024.
//
import SwiftUI
import RealmSwift

class RecentViewModel: ObservableObject {
    // MARK: - Properties
    @Published var recentlyPlayed: [RecentTrack] = []
    
    // MARK: - Private Properties
    private var repository: RealmTrackRepository
    private var notificationToken: NotificationToken?

    // MARK: - Initializer
    init() {
        self.repository = RealmTrackRepository.shared
        observeRecentlyPlayed()
    }
    // MARK: - Methods
    private func observeRecentlyPlayed() {
        repository.$recentlyPlayedTracks
            .receive(on: DispatchQueue.main)
            .assign(to: &$recentlyPlayed)
    }
    
    func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "00:00" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

