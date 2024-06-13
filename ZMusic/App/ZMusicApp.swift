//
//  ZMusicApp.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI

@main
struct ZMusicApp: App {
    var body: some Scene {
        WindowGroup {
            let trackURL = Bundle.main.url(forResource: "Скриптонит,Эндшпиль - Разбалованная", withExtension: "mp3")
            let trackURL2 = Bundle.main.url(forResource: "Gruppa Skryptonite - Podruga", withExtension: "mp3")

            let sampleTracks = [
                AudioTrack(title: "Скриптонит - Ага, ну", url: trackURL!),
                AudioTrack(title: "Gruppa Skryptonite - Podruga", url: trackURL2!)
            ]
            MusicPlayerView(tracks: sampleTracks)
        }
    }
}
