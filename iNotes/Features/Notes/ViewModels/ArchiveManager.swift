import Foundation

protocol ArchiveManager {
    func saveArchive(for noteID: UUID, isArchive: Bool)
    func loadArchive(for noteID: UUID) -> Bool
}

final class UserDefaultsArchiveManager: ArchiveManager {
    func saveArchive(for noteID: UUID, isArchive: Bool) {
        UserDefaults.standard.set(isArchive, forKey: "isArchive_\(noteID.uuidString)")
    }
    
    func loadArchive(for noteID: UUID) -> Bool {
        UserDefaults.standard.bool(forKey: "isArchive_\(noteID.uuidString)")
    }
}

