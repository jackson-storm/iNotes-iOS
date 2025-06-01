import SwiftUI
import Combine

struct EditNotesView: View {
    let note: Note
    
    @AppStorage("textScale") private var textScale: Double = 100
    @AppStorage("isPasswordCreated") var isPasswordCreated: Bool = false
    
    @ObservedObject var notesViewModel: NotesViewModel
    @ObservedObject var createPasswordViewModel: CreatePasswordViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var searchTextEditNotes: String
    
    @State private var isTapLike: Bool = false
    @State private var isTapArchive: Bool = false
    @State private var isTapLock: Bool = false
    
    @State private var isActiveSearch: Bool = false
    @State private var isActiveTextSize: Bool = false
    
    @State private var showShareSheet: Bool = false
    @State private var isSaved: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    @State private var isActiveEnterPassword: Bool = false
    @State private var isActiveSetPassword: Bool = false
    @State private var showCreatePasswordSheet = false
    
    @State private var undoStack: [(title: String, description: String)] = []
    @State private var redoStack: [(title: String, description: String)] = []
    
    init(note: Note, notesViewModel: NotesViewModel, createPasswordViewModel: CreatePasswordViewModel) {
        self.note = note
        self.notesViewModel = notesViewModel
        self.createPasswordViewModel = createPasswordViewModel
        
        let storedLike = UserDefaults.standard.bool(forKey: "isLiked_\(note.id.uuidString)")
        let storedArchive = UserDefaults.standard.bool(forKey: "isArchive_\(note.id.uuidString)")
        let storedLock = UserDefaults.standard.bool(forKey: "isLock_\(note.id.uuidString)")
        
        _description = State(initialValue: note.description)
        _title = State(initialValue: note.title)
        _isTapLike = State(initialValue: storedLike)
        _isTapArchive = State(initialValue: storedArchive)
        _isTapLock = State(initialValue: storedLock)
        _searchTextEditNotes = State(initialValue: "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !isTapLock {
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
                    isTapLock: $isTapLock,
                    searchText: searchTextEditNotes,
                    currentMatchIndex: notesViewModel.currentMatchIndex,
                    matchRanges: notesViewModel.matchRanges,
                    fontSize: textScale,
                    note: note
                )
            } else {
                InformationUnlockText(isActiveEnterPassword: $isActiveEnterPassword)
            }
        }
        .animation(.bouncy, value: isActiveSearch)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.backgroundHomePage)
        .toolbar {
            EditNotesNoteToolbar(
                note: note,
                title: $title,
                description: $description,
                isTapLike: $isTapLike,
                isTapLock: $isTapLock,
                isTapArchive: $isTapArchive,
                isActiveSearch: $isActiveSearch,
                isActiveTextSize: $isActiveTextSize,
                showDeleteAlert: $showDeleteAlert,
                isActiveEnterPassword: $isActiveEnterPassword,
                isActiveSetPassword: $isActiveSetPassword,
                isPasswordCreated: $isPasswordCreated,
                showCreatePasswordSheet: $showCreatePasswordSheet,
                notesViewModel: notesViewModel
            )
        }
        .sheet(isPresented: $isActiveEnterPassword) {
                EnterPasswordAlert(
                    isPresented: $isActiveEnterPassword,
                    isUnlocked: $isTapLock,
                    createPasswordViewModel: createPasswordViewModel
                )
            .presentationDetents([.fraction(0.20)])
            .presentationBackground(.backgroundComponents)
        }
        .sheet(isPresented: $showCreatePasswordSheet) {
            CreatePasswordView(createPasswordViewModel: createPasswordViewModel)
                .presentationBackground(Color.backgroundHomePage)
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
        .onDisappear {
            notesViewModel.update(noteID: note.id, title: title, description: description)
        }
        .onChange(of: description) { newDescription, _ in
            undoStack.append((title, newDescription))
            redoStack.removeAll()
            notesViewModel.update(noteID: note.id, title: title, description: newDescription)
            notesViewModel.updateMatches(in: newDescription, for: searchTextEditNotes)
        }
        .onChange(of: searchTextEditNotes) { _, _ in
            notesViewModel.updateMatches(in: description, for: searchTextEditNotes)
        }
    }
}


#Preview {
    ContentView()
}
