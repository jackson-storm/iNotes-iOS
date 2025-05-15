import Foundation

protocol NotesRepository {
    func save(_ notes: [Note])
    func load() -> [Note]
}

final class UserDefaultsNotesRepository: NotesRepository {
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
}
