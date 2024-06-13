//
//  PlayListView.swift
//  ZMusic
//
//  Created by Анна on 14.06.2024.
//

import SwiftUI

struct PlaylistView: View {
    @StateObject private var playlistManager = PlaylistManager()
    @State private var newPlaylistName = ""
    @State private var selectedPlaylist: UUID?

    var body: some View {
        VStack {
            TextField("Новое название плейлиста", text: $newPlaylistName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Создать плейлист") {
                playlistManager.createPlaylist(name: newPlaylistName, tracks: [])
                newPlaylistName = ""
            }
            .padding()

            List {
                ForEach(playlistManager.playlists) { playlist in
                    HStack {
                        Text(playlist.name)
                        Spacer()
                        Button("Удалить") {
                            playlistManager.deletePlaylist(id: playlist.id)
                        }
                    }
                    .onTapGesture {
                        selectedPlaylist = playlist.id
                    }
                }
            }
            .padding()
        }
        .onAppear {
            playlistManager.loadPlaylists()
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}

