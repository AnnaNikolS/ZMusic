//
//  AudioTrack.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import Foundation

struct AudioTrack: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}
