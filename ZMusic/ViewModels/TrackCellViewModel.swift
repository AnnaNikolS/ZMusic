//
//  TrackCellViewModel.swift
//  ZMusic
//
//  Created by Анна on 23.06.2024.
//

import Foundation

class TrackCellViewModel: ObservableObject {
    var name: String {
        track.name
    }
    
    var artist: String {
        track.artist ?? "Unknown artist"
    }
    
    var image: Data {
        track.image ?? Data()
    }
    
    let formatDuration: (_ duration: TimeInterval?) -> String
    var duration: String {
        formatDuration(track.duration)
    }
        
    private let track: Track
    init(formatDuration: @escaping (_: TimeInterval?) -> String, track: Track) {
        self.formatDuration = formatDuration
        self.track = track
    }
}
