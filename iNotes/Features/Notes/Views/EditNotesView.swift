import SwiftUI

struct EditNotesView: View {
    let note: Note
    
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var searchTextEditNotes: String
    
    @State private var isTapLike: Bool
    @State private var isTapArchive: Bool
    @State private var showDeleteAlert = false
    @State private var isActiveSearch: Bool = false
    
    @State private var undoStack: [(title: String, description: String)] = []
    @State private var redoStack: [(title: String, description: String)] = []
    
    @State private var matchRanges: [NSRange] = []
    @State private var currentMatchIndex: Int = 0
    
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
            searchBar
            noteHeader
            noteEditor
        }
        .animation(.bouncy, value: matchRanges)
        .animation(.bouncy, value: currentMatchIndex)
        .animation(.bouncy, value: isActiveSearch)
        .background(Color.backgroundHomePage.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { noteToolbar }
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
        .onChange(of: searchTextEditNotes) { _, _ in updateMatches() }
        .onChange(of: description) { _, _ in updateMatches() }
    }
    
    func updateMatches() {
        matchRanges.removeAll()
        currentMatchIndex = 0
        
        guard !searchTextEditNotes.isEmpty else { return }
        
        let pattern = NSRegularExpression.escapedPattern(for: searchTextEditNotes)
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let range = NSRange(location: 0, length: description.utf16.count)
        matchRanges = regex?.matches(in: description, range: range).map { $0.range } ?? []
    }
    
    private var searchBar: some View {
        HStack {
            VStack(alignment: .leading) {
                if isActiveSearch {
                    SearchBarEditNotes(
                        searchTextEditNotes: $searchTextEditNotes,
                        isActiveSearch: $isActiveSearch,
                        description: $description
                    )
                }
            }
            
            HStack(spacing: 15) {
                if isActiveSearch && !matchRanges.isEmpty {
                    Button {
                        currentMatchIndex = (currentMatchIndex - 1 + matchRanges.count) % matchRanges.count
                    } label: {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 22))
                    }
                    
                    Button {
                        currentMatchIndex = (currentMatchIndex + 1) % matchRanges.count
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 22))
                    }
                    
                    Text("\(currentMatchIndex + 1)/\(matchRanges.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }
                
                if isActiveSearch {
                    Button {
                        isActiveSearch = false
                        matchRanges = []
                    } label: {
                        Text("Ready")
                            .bold()
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.trailing, 10)
    }
    
    private var noteHeader: some View {
        HStack {
            TextField("Title", text: $title)
                .bold()
                .font(.system(size: 26))
                .padding(.horizontal)
                .padding(.top)
            
            Text(note.lastEdited.formatted(date: .abbreviated, time: .shortened))
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.trailing)
                .padding(.top)
        }
    }
    
    private var noteEditor: some View {
        HighlightedTextEditor(
            text: $description,
            searchText: searchTextEditNotes,
            currentMatchIndex: currentMatchIndex,
            allMatches: matchRanges
        )
        .padding(.horizontal, 11)
        .padding(.top, 8)
    }
    
    private var noteToolbar: some ToolbarContent {
        ToolbarItem(placement: isActiveSearch ? .topBarTrailing : .navigationBarTrailing) {
            HStack(spacing: 16) {
                Button {
                    if let last = undoStack.popLast() {
                        redoStack.append((title, description))
                        title = last.title
                        description = last.description
                    }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }.disabled(undoStack.isEmpty)
                
                Button {
                    if let next = redoStack.popLast() {
                        undoStack.append((title, description))
                        title = next.title
                        description = next.description
                    }
                } label: {
                    Image(systemName: "arrow.uturn.forward")
                }.disabled(redoStack.isEmpty)
                
                Button {
                    notesViewModel.toggleLike(for: note)
                    isTapLike.toggle()
                } label: {
                    Image(systemName: isTapLike ? "heart.fill" : "heart")
                        .foregroundStyle(isTapLike ? .red : .accentColor)
                }
                
                Button {
                    notesViewModel.toggleArchive(for: note)
                    isTapArchive.toggle()
                } label: {
                    Image(systemName: isTapArchive ? "archivebox.fill" : "archivebox")
                        .foregroundStyle(isTapArchive ? .blue : .accentColor)
                }
                
                Menu {
                    Button {
                        searchTextEditNotes = ""
                        isActiveSearch = true
                    } label: {
                        Text("Search in note")
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Button {
                        UIPasteboard.general.string = description
                    } label: {
                        Text("Copy text")
                        Image(systemName: "doc.on.doc")
                    }
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .font(.system(size: 17))
        }
    }
}

#Preview {
    ContentView()
}
