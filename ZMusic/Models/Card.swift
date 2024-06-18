//
//  Card.swift
//  ZMusic
//
//  Created by Анна on 18.06.2024.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
    let description: String
    let streamURL: URL?
}
