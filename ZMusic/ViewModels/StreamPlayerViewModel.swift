//
//  StreamPlayerViewModel.swift
//  ZMusic
//
//  Created by Анна on 16.06.2024.
//

import SwiftUI
import AVFoundation

class RadioStationsViewModel: ObservableObject {
    @Published var stations: [Stream] = []
    @Published var currentStation: Stream? = nil
    
    private var player: AVPlayer?
    
    init() {
        loadStations()
    }
    
    func loadStations() {
        stations = [
            Stream(
                title: "Русское радио",
                streamURL: URL(string: "https://rusradio.hostingradio.ru/rusradio128.mp3"),
                image: Image("russkoyeradio")
            ),
            
            Stream(
                title: "Europa Plus",
                streamURL: URL(string: "https://ep256.hostingradio.ru:8052/europaplus256.mp3"),
                image: Image("EuropaPlusBlack")
            ),
            
            Stream(
                title: "Радио максимум",
                streamURL: URL(string: "https://maximum.hostingradio.ru/maximum128.mp3"),
                image: Image("1maximum_stalo")
            ),
            
            Stream(
                title: "Radio Record",
                streamURL: URL(string: "https://radiorecord.hostingradio.ru/rr_main96.aacp"),
                image: Image("RadioRecordImage")
            ),
            
            
            Stream(
                title: "Радио Эрмитаж",
                streamURL: URL(string: "https://hermitage.hostingradio.ru/hermitage128.mp3"),
                image: Image("RadioErmitage")
            ),
            
            
            Stream(
                title: "DFM",
                streamURL: URL(string: "https://dfm.hostingradio.ru/dfm128.mp3"),
                image: Image("dfm-radio1")
            )
        ]
    }
    
    func playRadio(station: Stream) {
        guard let url = station.streamURL else {
            print("No URL for station: \(station.title)")
            return
        }
        
        if let current = currentStation, current.id == station.id {
            player?.pause()
            currentStation = nil
        } else {
            player = AVPlayer(url: url)
            player?.play()
            currentStation = station
        }
    }
    
    func stopRadio() {
        player?.pause()
        currentStation = nil
    }
}


