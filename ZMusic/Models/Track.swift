//
//  AudioTrack.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import Foundation
import SwiftUI

struct Track: Identifiable {
    var id = UUID()
    var name: String
    var data: Data
    var artist: String?
    var duration: TimeInterval?
    var image: Data?
}
