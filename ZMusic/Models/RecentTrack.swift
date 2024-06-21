//
//  RecentTrack.swift
//  ZMusic
//
//  Created by Анна on 21.06.2024.
//

import Foundation

struct RecentTrack: Identifiable, Codable {
    let id: UUID
    let name: String
    let artist: String?
    let duration: TimeInterval?
    let data: Data
    var image: Data?
}
