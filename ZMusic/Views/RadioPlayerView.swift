//
//  RadioPlayerView.swift
//  ZMusic
//
//  Created by Анна on 18.06.2024.
//

import SwiftUI
import ACarousel

struct RadioPlayerView: View {
    
    //MARK: - Private Properties
    @State private var currentIndex: Int = 0
    
    //MARK: - Properties
    @StateObject var viewModel = RadioCardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradientView(colors: [.darkPink, .pink, .orange, .black], location: .bottomTrailing, endRadius: 500)
                
                VStack(alignment: .leading) {
                    Text("Настройся на волну!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .fontDesign(.rounded)
                        .font(.system(size: 21))
                    Spacer()
                }
                
                VStack {
                    ACarousel(viewModel.cards,
                              id: \.streamURL,
                              index: $currentIndex,
                              spacing: 16,
                              headspace: 20,
                              sidesScaling: 0.8,
                              isWrap: true) { card in
                        RadioCardView(
                            card: card,
                            action: { viewModel.playRadio(station: card) },
                            isPlaying: viewModel.currentStation?.id == card.id
                        )
                    }
                              .frame(height: 300)
                              .padding(.top, 16)
                    Spacer()
                }
            }
            .navigationTitle("Radio")
            .customizeNavigationBar()
        }
    }
}

#Preview {
    RadioPlayerView()
}
