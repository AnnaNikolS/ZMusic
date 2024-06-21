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
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path())
            ZMusicView()
        }
    }
}
