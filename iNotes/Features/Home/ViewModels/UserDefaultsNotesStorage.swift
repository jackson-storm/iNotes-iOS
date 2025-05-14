import Foundation

protocol NotesStorage {
    func save(_ notes: [Note])
    func load() -> [Note]
    func saveLike(for noteID: UUID, isLiked: Bool)
    func loadLike(for noteID: UUID) -> Bool
}

final class UserDefaultsNotesStorage: NotesStorage {
    private let notesKey = "savedNotes"

    func save(_ notes: [Note]) {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: notesKey)
        }
    }

    func load() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: notesKey),
              let notes = try? JSONDecoder().decode([Note].self, from: data)
        else { return [] }
        return notes
    }

    func saveLike(for noteID: UUID, isLiked: Bool) {
        UserDefaults.standard.set(isLiked, forKey: "isLiked_\(noteID.uuidString)")
    }

    func loadLike(for noteID: UUID) -> Bool {
        UserDefaults.standard.bool(forKey: "isLiked_\(noteID.uuidString)")
    }
}
