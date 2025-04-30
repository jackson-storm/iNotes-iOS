import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [String] = []
    
    private let notesKey = "savedNotes"
    
    init() {
        loadNotes()
    }
    
    func saveNotes() {
        notes = Array(Set(notes))
        UserDefaults.standard.set(notes, forKey: notesKey)
    }
    
    func loadNotes() {
        if let savedNotes = UserDefaults.standard.array(forKey: notesKey) as? [String] {
            notes = savedNotes
        }
    }
    
    func deleteAllNotes() {
        notes.removeAll()
        saveNotes()
    }
    
    func noteExists(_ note: String) -> Bool {
        return notes.contains(note)
    }
}
