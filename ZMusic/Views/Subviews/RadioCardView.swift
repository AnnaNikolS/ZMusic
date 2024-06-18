//
//  RadioCardView.swift
//  ZMusic
//
//  Created by Анна on 18.06.2024.
//
import SwiftUI
import ACarousel

struct RadioCardView: View {
    let card: Card
    let action: () -> Void
    let isPlaying: Bool
    
    var body: some View {
        ZStack {
            card.color
                .scaledToFill()
                .frame(height: 250)
                .cornerRadius(30)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(card.title)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                    
                    Text(card.description)
                        .fontDesign(.rounded)
                    
                    Spacer()
                    
                    Button(action: action) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 35, height: 40)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 48)
                }
                .padding(.top, 40)
                .padding(.leading, 16)
                Spacer()
            }
        }
    }
}
