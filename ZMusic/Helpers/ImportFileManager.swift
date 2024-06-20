//
//  ImportFileManager.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import Foundation
import SwiftUI
import AVFoundation

struct ImportFileManager: UIViewControllerRepresentable {
    
    //MARK: - Properties
    @Binding var tracks: [Track]
    
    //MARK: - Coordinator Methods
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .open)
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: ImportFileManager
        
        init(parent: ImportFileManager) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            
            defer { url.stopAccessingSecurityScopedResource() }
            
            do {
                
                let document = try Data(contentsOf: url)
                
                let asset = AVAsset(url: url)
                
                var track = Track(name: url.lastPathComponent, data: document)
                
                let metadata = asset.metadata
                for item in metadata {
                    guard let key = item.commonKey?.rawValue, let value = item.value else { continue }
                    switch key {
                    case AVMetadataKey.commonKeyArtist.rawValue:
                        track.artist = value as? String
                    case AVMetadataKey.commonKeyArtwork.rawValue:
                        track.image = value as? Data
                    case AVMetadataKey.commonKeyTitle.rawValue:
                        track.name = value as? String ?? track.name
                    default:
                        break
                    }
                }
                
                track.duration = CMTimeGetSeconds(asset.duration)
                
                if !self.parent.tracks.contains(where: { $0.name == track.name }) {
                    DispatchQueue.main.async {
                        self.parent.tracks.append(track)
                    }
                } else {
                    print("Track already exists")
                }
                
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }
}
