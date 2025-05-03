import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    private enum Keys {
        static let notes = "savedNotes"
    }
    
    init() {
        loadNotes()
    }
    
    func addNoteIfNotExists(_ note: Note) -> Bool {
        guard !notes.contains(where: { $0.title == note.title }) else { return false }
        notes.append(note)
        saveNotes()
        return true
    }
    
    func deleteAllNotes() {
        guard !notes.isEmpty else { return }
        notes.removeAll()
        saveNotes()
    }
    
    private func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(data, forKey: Keys.notes)
        } catch {
            print("Error saving notes: \(error)")
        }
    }
    
    private func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: Keys.notes) else { return }
        do {
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Error loading notes: \(error)")
        }
    }
}
