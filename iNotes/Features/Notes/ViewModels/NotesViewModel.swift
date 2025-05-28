import SwiftUI

class NotesViewModel: ObservableObject {
    // MARK: - Published
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    @Published var sortType: NotesSortType = .creationDate
    @Published var lastScrollOffset: CGFloat = 0
    
    @AppStorage("selectedCategory") private var selectedCategoryRawValue: String = NoteCategory.all.rawValue
    
    var selectedCategory: NoteCategory {
        get { NoteCategory(rawValue: selectedCategoryRawValue) ?? .all }
        set { selectedCategoryRawValue = newValue.rawValue }
    }
    
    // MARK: - Dependencies
    private let repository: NotesRepository
    private let likesManager: LikesManager
    private let archiveManager: ArchiveManager
    
    // MARK: - Init
    init(repository: NotesRepository = UserDefaultsNotesRepository(),
         likesManager: LikesManager = UserDefaultsLikesManager(),
         archiveManager: ArchiveManager = UserDefaultsArchiveManager()) {
        self.repository = repository
        self.likesManager = likesManager
        self.archiveManager = archiveManager
        loadNotes()
    }
    
    // MARK: - Computed
    var filteredNotes: [Note] {
        let base = notes.filter {
            (selectedCategory == .all || $0.category == selectedCategory) &&
            (searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText))
        }
        
        switch sortType {
        case .creationDate: return base.sorted { $0.createdAt > $1.createdAt }
        case .lastModified: return base.sorted { $0.lastEdited > $1.lastEdited }
        case .name: return base.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
    }

    // MARK: - Actions
    func filterNotes(by category: NoteCategory) {
        selectedCategory = category
    }

    func delete(note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    func deleteAllNotes() {
        notes.removeAll()
        saveNotes()
    }

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

    func update(noteID: UUID, title: String, description: String) {
        guard let index = notes.firstIndex(where: { $0.id == noteID }) else { return }
        notes[index].title = title
        notes[index].description = description
        notes[index].lastEdited = Date()
        saveNotes()
    }
    
    func toggleArchive(for note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index].isArchive.toggle()
        archiveManager.saveArchive(for: notes[index].id, isArchive: notes[index].isArchive)
        saveNotes()
        
    }

    func toggleLike(for note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index].isLiked.toggle()
        likesManager.saveLike(for: notes[index].id, isLiked: notes[index].isLiked)
        saveNotes()
    }

    // MARK: - Persistence
    private func saveNotes() {
        repository.save(notes)
    }

    private func loadNotes() {
        notes = repository.load()
        for i in notes.indices {
            notes[i].isLiked = likesManager.loadLike(for: notes[i].id)
            notes[i].isArchive = archiveManager.loadArchive(for: notes[i].id)
        }
    }
}
