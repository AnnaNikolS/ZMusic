//
//  PlayList.swift
//  ZMusic
//
//  Created by Анна on 14.06.2024.
//

import Foundation

struct Playlist: Identifiable, Codable {
    let id = UUID()
    var name: String
    var tracks: [AudioTrack]
}
