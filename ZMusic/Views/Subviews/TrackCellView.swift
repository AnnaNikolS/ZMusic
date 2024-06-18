//
//  TrackCellView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI

struct TrackCellView: View {
    let track: Track
    
    var body: some View {
        HStack {
            if let uiImage = UIImage(data: track.image ?? Data()) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ZStack {
                    Color.white.frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Image(systemName: "music.note")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading) {
                Text(track.name)
                    .font(.headline)
                Text(track.artist ?? "Unknown artist")
            }
            
            Spacer()
            
            Text(formatDuration(track.duration))
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .foregroundStyle(.white)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "00:00" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TrackCellView(track: Track(name: "ttt", data: Data()))
}
