//
//  AudioPlayerViewModel.swift
//  ZMusic
//
//  Created by Анна on 13.06.2024.
//

import SwiftUI
import AVFAudio
import RealmSwift

class YourTracksViewModel: NSObject, ObservableObject {
    
    //MARK: - Properties
    @Published var tracks: [Track] = []
    @Published var currentIndex: Int?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    @Published var recentlyPlayed: [RecentTrack] = []
    
    // Эквалайзер и эффекты
    @Published var lowGain: Float = 0.0
    @Published var midGain: Float = 0.0
    @Published var highGain: Float = 0.0
    @Published var reverb: Float = 0.0
    @Published var echoDelay: Float = 0.0
    @Published var echoDecay: Float = 0.0
    
    //MARK: - Private Properties
    private var repository: RealmTrackRepository
    private var notificationToken: NotificationToken?
    private var timer: Timer?
    
    // Аудио-система
    private var audioEngine: AVAudioEngine!
    private var playerNode: AVAudioPlayerNode!
    private var audioFile: AVAudioFile?
    private var equalizer: AVAudioUnitEQ!
    private var reverbNode: AVAudioUnitReverb!
    private var echoNode: AVAudioUnitDelay!
    
    // MARK: - Initializer
    override init() {
        self.repository = RealmTrackRepository.shared
        super.init()
        setupAudioEngine()
        loadTracksFromRealm()
        observeRecentlyPlayed()
        startBackgroundTimer()
    }
    
    //MARK: - Getters
    var currentTrack: Track? {
        guard let currentIndex = currentIndex, tracks.indices.contains(currentIndex) else {
            return nil
        }
        return tracks[currentIndex]
    }
    
    // MARK: - Private Equalizer Methods
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        
        playerNode = AVAudioPlayerNode()
        equalizer = AVAudioUnitEQ(numberOfBands: 3)
        reverbNode = AVAudioUnitReverb()
        echoNode = AVAudioUnitDelay()
        
        audioEngine.attach(playerNode)
        audioEngine.attach(equalizer)
        audioEngine.attach(reverbNode)
        audioEngine.attach(echoNode)
        
        // Подключение узлов аудио-движка
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.connect(playerNode, to: equalizer, format: nil)
        audioEngine.connect(equalizer, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: mainMixer, format: nil)
        
        // Настройка эквалайзера
        equalizer.globalGain = 0.0 // Общий уровень усиления
        setupEQBands()
        
        // Настройка реверберации
        reverbNode.loadFactoryPreset(.largeRoom)
        reverbNode.wetDryMix = 0 // Уровень реверберации (0-100%)
        
        // Настройка задержки (эхо)
        echoNode.delayTime = 0 // Задержка в секундах
        echoNode.feedback = 0 // Уровень обратной связи (0-100%)
        
        try? audioEngine.start()
    }
    
    private func setupEQBands() {
        // Басы (низы)
        equalizer.bands[0].filterType = .lowShelf
        equalizer.bands[0].frequency = 100.0 // Частота в Гц
        equalizer.bands[0].bandwidth = 1.0 // Полоса пропускания
        equalizer.bands[0].gain = lowGain // Усиление
        
        // Средние частоты
        equalizer.bands[1].filterType = .parametric
        equalizer.bands[1].frequency = 1000.0
        equalizer.bands[1].bandwidth = 1.0
        equalizer.bands[1].gain = midGain
        
        // Высокие частоты
        equalizer.bands[2].filterType = .highShelf
        equalizer.bands[2].frequency = 10000.0
        equalizer.bands[2].bandwidth = 1.0
        equalizer.bands[2].gain = highGain
    }
    
    // MARK: - Methods
    func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "00:00" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
   
    func playAudio(track: Track) {
        do {
            let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.mp3")
            try track.data.write(to: tempFileURL)
            
            audioFile = try AVAudioFile(forReading: tempFileURL)
            
            playerNode.stop()
            audioEngine.stop()
            audioEngine.reset()
            setupAudioEngine()
            
            if let audioFile = audioFile {
                playerNode.scheduleFile(audioFile, at: nil)
                
                try audioEngine.start()
                playerNode.play()
                
                totalTime = calculateDuration(of: audioFile)
                currentTime = 0
                isPlaying = true
                if let index = tracks.firstIndex(where: { $0.id == track.id }) {
                    currentIndex = index
                }
                
                repository.saveTrack(track: track) // save in realm
                
                stopBackgroundTimer()
                startBackgroundTimer()
                
                playerNode.installTap(onBus: 0, bufferSize: 1024, format: audioFile.processingFormat) { [weak self] (buffer, when) in
                    guard let self = self else { return }
                    let playbackTime = Double(buffer.frameLength) / audioFile.processingFormat.sampleRate
                    DispatchQueue.main.async {
                        if self.currentTime /*+ playbackTime*/ >= self.totalTime {
                            self.audioDidFinishPlaying()
                        }
                    }
                }
            }
            
        } catch {
            print("Error in audio playback: \(error.localizedDescription)")
        }
        DispatchQueue.main.async {
            self.currentTime = 0
        }
    }

    func stopAudio() {
        playerNode.stop()
        audioEngine.stop()
        isPlaying = false
        stopBackgroundTimer()
    }
    
    func forward() {
        guard let currentIndex = currentIndex else { return }
        let nextIndex = currentIndex + 1 < tracks.count ? currentIndex + 1 : 0
        playAudio(track: tracks[nextIndex])
        
        DispatchQueue.main.async {
            self.currentTime = 0
        }
    }
    
    func backward() {
        guard let currentIndex = currentIndex else { return }
        let previousIndex = currentIndex > 0 ? currentIndex - 1 : tracks.count - 1
        playAudio(track: tracks[previousIndex])
    }
    
    func calculateSampleTime(from time: TimeInterval, sampleRate: Double) -> AVAudioFramePosition {
        return AVAudioFramePosition(time * sampleRate)
    }
    
    func calculateDuration(of audioFile: AVAudioFile) -> TimeInterval {
        let sampleRate = audioFile.processingFormat.sampleRate
        let totalSamples = audioFile.length
        return TimeInterval(totalSamples) / sampleRate
    }
    
    func seekAudio(time: TimeInterval) {
        guard let audioFile = audioFile else { return }
        
        let duration = calculateDuration(of: audioFile)
        let validTime = max(0, min(time, duration))
        
        playerNode.stop()
        
        let sampleRate = audioFile.processingFormat.sampleRate
        let sampleTime = calculateSampleTime(from: validTime, sampleRate: sampleRate)
        let remainingSamples = AVAudioFrameCount(audioFile.length - sampleTime)
        
        guard sampleTime < audioFile.length else {
            print("Sample time exceeds audio file length")
            return
        }
        
        playerNode.scheduleSegment(audioFile, startingFrame: sampleTime, frameCount: remainingSamples, at: nil) {
            DispatchQueue.main.async {
                self.currentTime = validTime
                if self.currentTime >= self.totalTime {
                    self.audioDidFinishPlaying()
                }
            }
        }
        playerNode.play()
    }
    
    func updateCurrentTime(to time: TimeInterval) {
        DispatchQueue.main.async {
            self.currentTime = time
        }
    }
    
    func playPause() {
        if isPlaying {
            playerNode.pause()
        } else {
            playerNode.play()
        }
        isPlaying.toggle()
    }
    
    //MARK: - Realm Methods
    private func loadTracksFromRealm() {
        self.tracks = repository.fetchAllTracks().map { recentTrack in
            Track(
                id: recentTrack.id,
                name: recentTrack.name,
                data: recentTrack.data,
                artist: recentTrack.artist,
                duration: recentTrack.duration,
                image: recentTrack.image
            )
        }
    }
    
    private func observeRecentlyPlayed() {
        repository.$recentlyPlayedTracks
            .receive(on: DispatchQueue.main)
            .assign(to: &$recentlyPlayed)
    }
    
    func delete(offsets: IndexSet) {
        if let first = offsets.first {
            stopAudio()
            let track = tracks[first]
            tracks.remove(at: first)
            repository.deleteTrack(id: track.id) // delete in realm
        }
    }
    
    func addTrack(track: Track) {
        repository.saveTrack(track: track)
    }
    
    // Equalizer method
    func applyEqualizerSettings() {
        equalizer.bands[0].gain = lowGain
        equalizer.bands[1].gain = midGain
        equalizer.bands[2].gain = highGain
        
        reverbNode.wetDryMix = reverb
        
        echoNode.delayTime = TimeInterval(echoDelay)
        echoNode.feedback = echoDecay
    }
  
    //MARK: - Timer Methods
    private func startBackgroundTimer() {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.isPlaying {
                    self.currentTime += 1.0
                    if self.currentTime >= self.totalTime {
                        self.audioDidFinishPlaying()
                    }
                }
            }
        }
    
    private func stopBackgroundTimer() {
            timer?.invalidate()
            timer = nil
        }
    
    private func audioDidFinishPlaying() {
        DispatchQueue.main.async {
            self.stopBackgroundTimer()
            self.currentTime = 0
            self.forward()
        }
    }
    
    deinit {
        stopBackgroundTimer()
    }
}

