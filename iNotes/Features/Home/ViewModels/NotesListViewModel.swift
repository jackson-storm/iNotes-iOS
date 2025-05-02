import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [String] = []
    
    private enum Keys {
        static let notes = "savedNotes"
    }
    
    init() {
        loadNotes()
    }
    
    func addNoteIfNotExists(_ note: String) -> Bool {
        guard !noteExists(note) else { return false }
        notes.append(note)
        saveNotes()
        return true
    }
    
    func deleteAllNotes() {
        guard !notes.isEmpty else { return }
        notes.removeAll()
        saveNotes()
    }
    
    func noteExists(_ note: String) -> Bool {
        notes.contains(note)
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
            notes = try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Error loading notes: \(error)")
        }
    }
}
