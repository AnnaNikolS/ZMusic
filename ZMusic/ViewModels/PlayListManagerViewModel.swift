////
////  PlayListManagerViewModel.swift
////  ZMusic
////
////  Created by Анна on 14.06.2024.
////
//
//import SwiftUI
//
//class PlaylistManager: ObservableObject {
//    @Published var playlists: [Playlist] = []
//
//    init() {
//        loadPlaylists()
//    }
//
//    func createPlaylist(name: String, tracks: [AudioTrack]) {
//        let newPlaylist = Playlist(name: name, tracks: tracks)
//        playlists.append(newPlaylist)
//        savePlaylists()
//    }
//
//    func deletePlaylist(id: UUID) {
//        playlists.removeAll { $0.id == id }
//        savePlaylists()
//    }
//
//    func addTrack(to playlistId: UUID, track: AudioTrack) {
//        if let index = playlists.firstIndex(where: { $0.id == playlistId }) {
//            playlists[index].tracks.append(track)
//            savePlaylists()
//        }
//    }
//
//    func removeTrack(from playlistId: UUID, trackId: UUID) {
//        if let index = playlists.firstIndex(where: { $0.id == playlistId }) {
//            playlists[index].tracks.removeAll { $0.id == trackId }
//            savePlaylists()
//        }
//    }
//
//    func loadPlaylists() {
//        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("playlists.json") else { return }
//        if let data = try? Data(contentsOf: url) {
//            if let decoded = try? JSONDecoder().decode([Playlist].self, from: data) {
//                playlists = decoded
//            }
//        }
//    }
//
//    private func savePlaylists() {
//        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("playlists.json") else { return }
//        if let data = try? JSONEncoder().encode(playlists) {
//            try? data.write(to: url)
//        }
//    }
//}
