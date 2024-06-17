//
//  Stream.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import Foundation
import SwiftUI

struct Stream: Identifiable {
    let id = UUID()
    let title: String
    let streamURL: URL?
    let image: Image
}
