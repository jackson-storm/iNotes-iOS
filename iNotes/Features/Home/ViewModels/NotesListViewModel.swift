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
    
    func delete(note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
        filterNotes(by: selectedCategory)
    }
    
    func toggleLike(for note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index].isLiked.toggle()

        let likeKey = "isLiked_\(note.id.uuidString)"
        UserDefaults.standard.set(notes[index].isLiked, forKey: likeKey)

        saveNotes()
        filterNotes(by: selectedCategory)
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
    
    private func loadLikesFromStorage() {
        for index in notes.indices {
            let key = "isLiked_\(notes[index].id.uuidString)"
            notes[index].isLiked = UserDefaults.standard.bool(forKey: key)
        }
    }
    
    private func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: Keys.notes) else { return }
        do {
            notes = try JSONDecoder().decode([Note].self, from: data)
            loadLikesFromStorage()
            filteredNotes = notes
        } catch {
            print("Error loading notes: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
