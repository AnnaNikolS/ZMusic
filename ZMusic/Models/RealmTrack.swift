//
//  RealmTrack.swift
//  ZMusic
//
//  Created by Анна on 21.06.2024.
//

import Foundation
import RealmSwift

class RealmTrack: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var artist: String?
    @Persisted var duration: TimeInterval
    @Persisted var audioData: Data
    @Persisted var image: Data?
    
    convenience init(track: Track) {
        self.init()
        self.id = track.id.uuidString
        self.name = track.name
        self.artist = track.artist
        self.duration = track.duration ?? 0.0
        self.audioData = track.data
        self.image = track.image
    }
}
