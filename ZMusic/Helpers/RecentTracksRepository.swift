//
//  RecentTracksRepository.swift
//  ZMusic
//
//  Created by Анна on 21.06.2024.
//

import Foundation
import RealmSwift

import RealmSwift

class RealmTrackRepository: ObservableObject {
    
    // MARK: - Properties
    @Published var recentlyPlayedTracks: [RecentTrack] = []
    @Published var realmTracks: [RealmTrack] = []
    static let shared = RealmTrackRepository()
    
    // MARK: - Private Properties
    private var realm: Realm
    private var notificationToken: NotificationToken?

    // MARK: - Initializer
    private init() {
        realm = try! Realm()
        setupNotification()
    }

    // MARK: - Methods
    // Метод для наблюдения за изменениями в Realm
    private func setupNotification() {
        let results = realm.objects(RealmTrack.self)
        notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(let collection):
                self.updateTracks(from: collection)
            case .update(let collection, _, _, _):
                self.updateTracks(from: collection)
            case .error(let error):
                print("Error observing Realm changes: \(error.localizedDescription)")
            }
        }
    }

    private func updateTracks(from collection: Results<RealmTrack>) {
        self.recentlyPlayedTracks = collection.map { realmTrack in
            RecentTrack(
                id: UUID(uuidString: realmTrack.id) ?? UUID(),
                name: realmTrack.name,
                artist: realmTrack.artist,
                duration: realmTrack.duration,
                data: realmTrack.audioData,
                image: realmTrack.image
            )
        }
    }

    // Получение всех треков из Realm
    func fetchAllTracks() -> [RecentTrack] {
        let realmTracks = realm.objects(RealmTrack.self)
        return realmTracks.map { realmTrack in
            RecentTrack(
                id: UUID(uuidString: realmTrack.id) ?? UUID(),
                name: realmTrack.name,
                artist: realmTrack.artist,
                duration: realmTrack.duration,
                data: realmTrack.audioData,
                image: realmTrack.image
            )
        }
    }

    // Сохранение трека в Realm
    func saveTrack(track: Track) {
        let realmTrack = RealmTrack()
        realmTrack.id = track.id.uuidString
        realmTrack.name = track.name
        realmTrack.artist = track.artist
        realmTrack.duration = track.duration ?? 0.0
        realmTrack.image = track.image
        realmTrack.audioData = track.data

        do {
            try realm.write {
                realm.add(realmTrack, update: .modified)
            }
        } catch {
            print("Error saving track to Realm: \(error.localizedDescription)")
        }
    }

    // Удаление трека из Realm
    func deleteTrack(id: UUID) {
        if let realmTrack = realm.object(ofType: RealmTrack.self, forPrimaryKey: id.uuidString) {
            do {
                try realm.write {
                    realm.delete(realmTrack)
                }
            } catch {
                print("Error deleting track from Realm: \(error.localizedDescription)")
            }
        }
    }
}
