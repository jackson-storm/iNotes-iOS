import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var filteredNotes: [Note] = []
    @Published var selectedCategory: NoteCategory = .all
    
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
        filterNotes(by: selectedCategory)
        return true
    }
    
    func filterNotes(by category: NoteCategory) {
        withAnimation(.easeOut) {
            if category == .all {
                filteredNotes = notes
            } else {
                filteredNotes = notes.filter { $0.category == category }
            }
        }
    }
    
    func deleteAllNotes() {
        guard !notes.isEmpty else { return }
        notes.removeAll()
        saveNotes()
        filterNotes(by: selectedCategory)
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
            filteredNotes = notes
        } catch {
            print("Error loading notes: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
