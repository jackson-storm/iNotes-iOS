import SwiftUI

class NotesViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    @Published var sortType: NotesSortType = .creationDate
    
    @AppStorage("selectedCategory") private var selectedCategoryRawValue: String = NoteCategory.all.rawValue
    
    var filteredNotes: [Note] {
        let baseNotes = notes.filter { note in
            (selectedCategory == .all || note.category == selectedCategory)
            && (searchText.isEmpty || note.title.localizedCaseInsensitiveContains(searchText) || note.description.localizedCaseInsensitiveContains(searchText))
        }
        
        switch sortType {
        case .creationDate:
            return baseNotes.sorted { $0.createdAt > $1.createdAt }
        case .lastModified:
            return baseNotes.sorted { $0.lastEdited > $1.lastEdited }
        case .name:
            return baseNotes.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
    }
    
    var selectedCategory: NoteCategory {
        get { NoteCategory(rawValue: selectedCategoryRawValue) ?? .all }
        set { selectedCategoryRawValue = newValue.rawValue }
    }
    
    // MARK: - Init
    private let storage: NotesStorage

    init(storage: NotesStorage = UserDefaultsNotesStorage()) {
        self.storage = storage
        loadNotes()
    }
    
    // MARK: - Note Management
    func delete(notesWithIDs ids: Set<UUID>) {
        notes.removeAll { ids.contains($0.id) }
        saveNotes()
    }
    
    func addNoteIfNotExists(_ note: Note) -> Bool {
        guard !notes.contains(where: { $0.title == note.title }) else { return false }
        notes.append(note)
        saveNotes()
        return true
    }
    
    func delete(note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    func deleteAllNotes() {
        guard !notes.isEmpty else { return }
        notes.removeAll()
        saveNotes()
    }

    func toggleLike(for note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index].isLiked.toggle()
        storage.saveLike(for: notes[index].id, isLiked: notes[index].isLiked)
        saveNotes()
    }
    
    func update(noteID: UUID, title: String, description: String) {
        guard let index = notes.firstIndex(where: { $0.id == noteID }) else { return }
        notes[index].title = title
        notes[index].description = description
        notes[index].lastEdited = Date()
        saveNotes()
        filterNotes(by: selectedCategory)
    }
    
    // MARK: - Filtering
    func filterNotes(by category: NoteCategory) {
        selectedCategory = category
    }
    
    // MARK: - Persistence
    private func saveNotes() {
        storage.save(notes)
    }

    private func loadNotes() {
        notes = storage.load()
        loadLikesFromStorage()
    }

    private func loadLikesFromStorage() {
        for index in notes.indices {
            notes[index].isLiked = storage.loadLike(for: notes[index].id)
        }
    }
}
