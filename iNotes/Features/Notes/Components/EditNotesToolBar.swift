import SwiftUI

struct EditNotesNoteToolbar: ToolbarContent {
    let note: Note
    @Binding var title: String
    @Binding var description: String
    
    @Binding var isTapLike: Bool
    @Binding var isTapArchive: Bool
    @Binding var isActiveSearch: Bool
    @Binding var isActiveTextSize: Bool
    @Binding var showDeleteAlert: Bool
    
    @Binding var undoStack: [(title: String, description: String)]
    @Binding var redoStack: [(title: String, description: String)]
    
    let notesViewModel: NotesViewModel
    
    var body: some ToolbarContent {
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
                        isActiveSearch = true
                    } label: {
                        Text("Search in note")
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Button {
                        isActiveTextSize = true
                    } label: {
                        Label("Font size", systemImage: "textformat.size")
                    }
                    
                    ShareLink(item: description) {
                        Label("Share a note", systemImage: "square.and.arrow.up")
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
            .font(.system(size: 18))
        }
    }
}
