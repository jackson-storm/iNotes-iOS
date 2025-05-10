import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var filteredNotes: [Note] = []
    
    @AppStorage("selectedCategory") private var selectedCategoryRawValue: String = NoteCategory.all.rawValue {
        didSet {
            applyFilters()
        }
    }
    
    var selectedCategory: NoteCategory {
        get { NoteCategory(rawValue: selectedCategoryRawValue) ?? .all }
        set { selectedCategoryRawValue = newValue.rawValue }
    }

    @Published var searchText: String = "" {
        didSet {
            applyFilters()
        }
    }

    private enum Keys {
        static let notes = "savedNotes"
    }

    init() {
        loadNotes()
    }

    // MARK: - Add Note
    func addNoteIfNotExists(_ note: Note) -> Bool {
        guard !notes.contains(where: { $0.title == note.title }) else { return false }
        notes.append(note)
        saveNotes()
        applyFilters()
        return true
    }

    // MARK: - Delete
    func delete(note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
        applyFilters()
    }

    func deleteAllNotes() {
        guard !notes.isEmpty else { return }
        notes.removeAll()
        saveNotes()
        applyFilters()
    }

    // MARK: - Like
    func toggleLike(for note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index].isLiked.toggle()
        let likeKey = "isLiked_\(note.id.uuidString)"
        UserDefaults.standard.set(notes[index].isLiked, forKey: likeKey)
        saveNotes()
        applyFilters()
    }

    // MARK: - Category Filter
    func filterNotes(by category: NoteCategory) {
        selectedCategory = category
        applyFilters()
    }

    // MARK: - Core Filtering Logic
    private func applyFilters() {
        withAnimation(.easeOut) {
            filteredNotes = notes.filter { note in
                let matchesCategory = selectedCategory == .all || note.category == selectedCategory
                let matchesSearch = searchText.isEmpty
                    || note.title.localizedCaseInsensitiveContains(searchText)
                    || note.description.localizedCaseInsensitiveContains(searchText)
                return matchesCategory && matchesSearch
            }
        }
    }

    // MARK: - Persistence
    func saveNotes() {
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
            loadLikesFromStorage()
            applyFilters()
        } catch {
            print("Error loading notes: \(error)")
        }
    }

    private func loadLikesFromStorage() {
        for index in notes.indices {
            let key = "isLiked_\(notes[index].id.uuidString)"
            notes[index].isLiked = UserDefaults.standard.bool(forKey: key)
        }
    }
}
