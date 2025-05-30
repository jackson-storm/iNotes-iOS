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
    
    let notesViewModel: NotesViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 16) {
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
