import SwiftUI

struct EditNotesView: View {
    let note: Note
    
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var searchTextEditNotes: String
    
    @State private var isTap: Bool
    @State private var showDeleteAlert = false
    @State private var isActiveSearch: Bool = false
    
    @State private var undoStack: [(title: String,  description: String)] = []
    @State private var redoStack: [(title: String,  description: String)] = []
    
    init(note: Note, notesViewModel: NotesViewModel) {
        self.note = note
        self.notesViewModel = notesViewModel
        let stored = UserDefaults.standard.bool(forKey: "isLiked_\(note.id.uuidString)")
        
        _description = State(initialValue: note.description)
        _title = State(initialValue: note.title)
        _isTap = State(initialValue: stored)
        _searchTextEditNotes = State(initialValue: "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            noteHeader
            noteEditor
        }
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
    }
    
    private var searchBar: some View {
        VStack(alignment: .leading) {
            if isActiveSearch {
                SearchBarEditNotes(searchTextEditNotes: $searchTextEditNotes, isActiveSearch: $isActiveSearch, description: $description)
                
            }
        }
    }
    
    private var noteHeader: some View {
        HStack {
            TextField("Title", text: $title)
                .bold()
                .font(.system(size: 22))
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
        let highlightedText: AttributedString? = {
            guard isActiveSearch, !searchTextEditNotes.isEmpty else { return nil }
            let lowercasedSearch = searchTextEditNotes.lowercased()
            let attributed = NSMutableAttributedString(string: description)
            let fullRange = NSRange(location: 0, length: attributed.length)
            
            attributed.addAttribute(.foregroundColor, value: UIColor.label, range: fullRange)
            
            let regex = try? NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: lowercasedSearch), options: .caseInsensitive)
            
            regex?.enumerateMatches(in: description, options: [], range: fullRange) { match, _, _ in
                if let matchRange = match?.range {
                    attributed.addAttribute(.backgroundColor, value: UIColor.systemYellow.withAlphaComponent(0.5), range: matchRange)
                }
            }
            return AttributedString(attributed)
        }()
        return ZStack(alignment: .topLeading) {
            TextEditor(text: $description)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 11)
                .padding(.top, 8)
                .background(Color.backgroundHomePage)
            
            if let highlightedText {
                Text(highlightedText)
                    .padding()
                    .background(Color.clear)
                    .allowsHitTesting(false)
            }
        }
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
                    isTap.toggle()
                } label: {
                    Image(systemName: isTap ? "heart.fill" : "heart")
                        .foregroundStyle(isTap ? .red : .accentColor)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "archivebox")
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
