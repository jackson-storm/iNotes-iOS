import SwiftUI
import Combine

struct CreateEditNotesView: View {
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
    @State private var isPresented: Bool = false
    
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
                lastEdited: note.lastEdited
            )
            
            NoteEditorSection(
                description: $description,
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
            CreateEditNotesToolbar (
                note: note,
                title: $title,
                description: $description,
                isTapLike: $isTapLike,
                isTapArchive: $isTapArchive,
                isPresented: $isPresented,
                notesViewModel: notesViewModel
            )
        }
    }
}

#Preview {
    ContentView()
}

