//
//  YourTracksView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI

struct YourTracksView: View {
    @StateObject var viewModel = YourTracksViewModel()
    @State private var showFiles = false
    @State private var showDetails = false
    @State private var isDragging = false
    @Namespace private var playerAnimation
    
    var frameImage: CGFloat {
        showDetails ? 290 : 60
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                RadialGradientView(colors: [.red, .purple, .blue, .black], location: .bottom, endRadius: 500)
                
                VStack {
                    // list of tracks
                    List {
                        ForEach(viewModel.tracks) { track in
                            TrackCellView(track: track, formatDuration: viewModel.formatDuration(_:))
                                .onTapGesture {
                                    viewModel.playAudio(track: track)
                                }
                        }
                    }
                    .navigationTitle("Your Tracks")
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    // player
                    if viewModel.currentTrack != nil {
                        
                        Player()
                            .frame(height: showDetails ? UIScreen.main.bounds.height : 70)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    self.showDetails.toggle()
                                }
                            }
                    }
                }
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
    
    //MARK: - Methods
    @ViewBuilder
    private func Player() -> some View {
        VStack {
            // player mini
            HStack {
                if let uiImage = UIImage(data: viewModel.currentTrack?.image ?? Data()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: frameImage, height: frameImage)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, showDetails ? 35 : 0)
                } else {
                    ZStack {
                        Color.white.frame(width: frameImage, height: frameImage)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, showDetails ? 35 : 0)
                }
                
                if !showDetails {
                    /// упростить
                    VStack(alignment: .leading) {
                        if let currentTrack = viewModel.currentTrack {
                            Text(currentTrack.name)
                                .font(.headline)
                            
                            Text(currentTrack.artist ?? "Unknown artist")
                        }
                    }
                    .matchedGeometryEffect(id: "Track", in: playerAnimation)
                    
                    Spacer()
                    
                    customButton(
                        size: .title,
                        action: { viewModel.playPause() },
                        color: .white,
                        name: viewModel.isPlaying ? "pause.fill" : "play.fill"
                    )
                }
            }
            .padding()
            .background(showDetails ? .clear : .black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding([.leading, .trailing], 16)
            .padding(.bottom, 48)
            
            if showDetails {
                VStack {
                    if let currentTrack = viewModel.currentTrack {
                        Text(currentTrack.name)
                            .font(.title2)
                            .bold()
                            .frame(minWidth: UIScreen.main.bounds.width - 48)
                        Text(currentTrack.artist ?? "Unknown artist")
                            .frame(minWidth: UIScreen.main.bounds.width - 48)
                    }
                }
                .matchedGeometryEffect(id: "Track", in: playerAnimation)
                .offset(y: -60)
                
                VStack {
                    HStack {
                        Text("\(viewModel.formatDuration(viewModel.currentTime))")
                        Spacer()
                        Text("\(viewModel.formatDuration(viewModel.totalTime))")
                    }
                    .offset(y: -38)
                    
                    Slider(value: $viewModel.currentTime, in: 0...viewModel.totalTime) { editing in
                        isDragging = editing
                        if !editing {
                            viewModel.seekAudio(time: viewModel.currentTime)
                        }
                    }
                    .offset(y: -38)
                    .onAppear {
                        Timer.scheduledTimer(
                            withTimeInterval: 0.5,
                            repeats: true) { _ in
                                viewModel.update()
                            }
                    }
                    
                    HStack(spacing: 40) {
                        customButton(
                            size: .title2,
                            action: {},
                            color: .white,
                            name: "backward.fill"
                        )
                        
                        customButton(
                            size: .system(size: 56),
                            action: { viewModel.playPause() },
                            color: .white,
                            name: viewModel.isPlaying ? "pause.fill" : "play.fill"
                        )
                        
                        customButton(
                            size: .title2,
                            action: {},
                            color: .white,
                            name: "forward.fill"
                        )
                    }
                    .offset(y: -30)
                }
                .padding(.horizontal, 40)
            }
        }
    }
    
    private func customButton(size: Font, action: @escaping () -> Void, color: Color, name: String) -> some View {
        Button(action: action) {
            Image(systemName: name)
                .foregroundStyle(color)
                .font(size)
        }
    }
}

#Preview {
    YourTracksView()
}


