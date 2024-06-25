//
//  TrackCellView.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import SwiftUI

struct TrackCellView: View {    
    
    //MARK: - Properties
    @ObservedObject var viewModel: TrackCellViewModel
    
    var body: some View {
        HStack {
            if let uiImage = UIImage(data: viewModel.image) {
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
                Text(viewModel.name)
                    .font(.headline)
                Text(viewModel.artist)
            }
            
            Spacer()
            
            Text(viewModel.duration)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .foregroundStyle(.white)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
