//
//  YourTracksView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI

struct YourTracksView: View {
    @StateObject var viewModel = YourTracksViewModel()
    @State var showFiles = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradientView(colors: [.red, .purple, .blue, .black], location: .bottom, endRadius: 500)
                List {
                    ForEach(viewModel.tracks) { track in
                        TrackCellView(track: track)
                            .onTapGesture {
                                viewModel.playAudio(track: track)
                            }
                    }
                }
                .navigationTitle("Your Tracks")
                .listStyle(.plain)
            }
            .customizeNavigationBar()
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showFiles.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showFiles) {
            ImportFileManager(tracks: $viewModel.tracks).ignoresSafeArea()
        }
    }
}

#Preview {
    YourTracksView()
}


