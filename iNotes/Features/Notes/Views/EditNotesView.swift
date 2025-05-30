import SwiftUI
import Combine

struct EditNotesView: View {
    let note: Note
    
    @AppStorage("textScale") private var textScale: Double = 100
    
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var searchTextEditNotes: String
    
    @State private var isTapLike: Bool = false
    @State private var isTapArchive: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var isActiveSearch: Bool = false
    @State private var isActiveTextSize: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var isSaved: Bool = false
    
    @State private var undoStack: [(title: String, description: String)] = []
    @State private var redoStack: [(title: String, description: String)] = []

    init(note: Note, notesViewModel: NotesViewModel) {
        self.note = note
        self.notesViewModel = notesViewModel
        
        let storedLike = UserDefaults.standard.bool(forKey: "isLiked_\(note.id.uuidString)")
        let storedArchive = UserDefaults.standard.bool(forKey: "isArchive_\(note.id.uuidString)")
        
        _description = State(initialValue: note.description)
        _title = State(initialValue: note.title)
        _isTapLike = State(initialValue: storedLike)
        _isTapArchive = State(initialValue: storedArchive)
        _searchTextEditNotes = State(initialValue: "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBarSection(
                isActiveSearch: $isActiveSearch,
                searchTextEditNotes: $searchTextEditNotes,
                description: $description,
                matchRanges: $notesViewModel.matchRanges,
                currentMatchIndex: $notesViewModel.currentMatchIndex)
            
            TextSizeSection(
                isActiveTextSize: $isActiveTextSize,
                textScale: $textScale
            )
        
            NoteHeaderSection(
                title: $title,
                isSaved: $isSaved,
                lastEdited: note.lastEdited
            )
            
            NoteEditorSection(
                description: $description,
                isSaved: $isSaved,
                searchText: searchTextEditNotes,
                currentMatchIndex: notesViewModel.currentMatchIndex,
                matchRanges: notesViewModel.matchRanges,
                fontSize: textScale
            )
        }
        .animation(.bouncy, value: isActiveSearch)
        .animation(.bouncy, value: isActiveTextSize)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.backgroundHomePage)
        .toolbar {
            EditNotesNoteToolbar(
                note: note,
                title: $title,
                description: $description,
                isTapLike: $isTapLike,
                isTapArchive: $isTapArchive,
                isActiveSearch: $isActiveSearch,
                isActiveTextSize: $isActiveTextSize,
                showDeleteAlert: $showDeleteAlert,
                notesViewModel: notesViewModel
            )
        }
        .alert("Delete note?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                notesViewModel.delete(note: note)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .onChange(of: title) { newTitle, _ in
            undoStack.append((title, description))
            redoStack.removeAll()
            notesViewModel.update(noteID: note.id, title: newTitle, description: description)
        }
        .onChange(of: description) { newDescription, _ in
            undoStack.append((title, description))
            redoStack.removeAll()
            notesViewModel.update(noteID: note.id, title: title, description: newDescription)
        }
        .onChange(of: searchTextEditNotes) { _, _ in
            notesViewModel.updateMatches(in: description, for: searchTextEditNotes)
        }
        .onChange(of: description) { _, _ in
            notesViewModel.updateMatches(in: description, for: searchTextEditNotes)
        }
    }
}

#Preview {
    ContentView()
}
