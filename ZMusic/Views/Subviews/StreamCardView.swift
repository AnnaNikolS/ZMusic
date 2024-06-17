//
//  StreamCardView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI

struct StreamCardView: View {
    let title: String
    let image: Image
    let isPlaying: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(spacing: 20) {
                Text(title)
                    .frame(width: UIScreen.main.bounds.width / 2 + 17, alignment: .leading)
                    .font(.system(size: 25))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                
                
                Button(action: action) {
                    if isPlaying {
                        ZStack {
                            Color.indigo
                                .frame(width: 90, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Image(systemName: "pause")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                        }
                    } else {
                        ZStack {
                            Color.indigo
                                .frame(width: 90, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.indigo.opacity(0.15))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 10)
    }
}
