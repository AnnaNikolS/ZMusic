//
//  TrackCellView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI

struct TrackCellView: View {
    let track: Track
    let formatDuration: (_ duration: TimeInterval?) -> String
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
}
