//
//  RadioPlayerViewModel.swift
//  ZMusic
//
//  Created by Анна on 18.06.2024.
//

import Foundation
import SwiftUI
import AVFoundation


class RadioCardViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var cards: [Card] = []
    @Published var currentStation: Card? = nil
    
    //MARK: - Private Properties
    private var player: AVPlayer?
    
    // MARK: - Initializer
    init() {
        loadCards()
    }
    
    func loadCards() {
        cards = [
            Card(
                color: .pink,
                title: "Русское радио",
                description: "Русское радио — это станция, где звучат знакомые мелодии, которые перенесут вас в самые теплые уголки души, подарят радость и ностальгию.",
                streamURL: URL(string: "https://rusradio.hostingradio.ru/rusradio128.mp3")
            ),
            
            Card(
                color: .orange,
                title: "Europa Plus",
                description: "Europa Plus — это энергетический коктейль из самых горячих хитов. Станция, которая заряжает позитивом и создает атмосферу праздника каждый день.",
                streamURL: URL(string: "https://ep256.hostingradio.ru:8052/europaplus256.mp3")
            ),
            
            Card(
                color: .red,
                title: "Радио максимум",
                description: "Радио Максимум — это волна адреналина и драйва, где звучит только самое свежее и громкое. Здесь встречаются рок, альтернатива и лучшие хиты.",
                streamURL: URL(string: "https://maximum.hostingradio.ru/maximum128.mp3")
            ),
            
            Card(
                color: .green,
                title: "Radio Record",
                description: "Radio Record — это пульс клубной жизни и эпицентр электронной музыки. Настройся на волну, где каждый бит — это шаг на танцпол.",
                streamURL: URL(string: "https://radiorecord.hostingradio.ru/rr_main96.aacp")
            ),
            
            Card(
                color: .purple,
                title: "Радио Эрмитаж",
                description: "Радио Эрмитаж — это музыкальная галерея джаза и классики, где каждый трек — произведение искусства.",
                streamURL: URL(string: "https://hermitage.hostingradio.ru/hermitage128.mp3")
            ),
            
            Card(
                color: .brown,
                title: "DFM",
                description: "DFM — это ритм современной поп-культуры и хит-парад танцевальных треков. Включи волну, где каждый звук — это энергия движений.",
                streamURL: URL(string: "https://dfm.hostingradio.ru/dfm128.mp3")
            )
        ]
    }
    
    //MARK: - Methods
    func playRadio(station: Card) {
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
