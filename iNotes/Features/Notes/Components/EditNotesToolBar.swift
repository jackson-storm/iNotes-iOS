import SwiftUI

struct EditNotesNoteToolbar: ToolbarContent {
    let note: Note

    @Binding var title: String
    @Binding var description: String
    
    @Binding var isTapLike: Bool
    @Binding var isTapLock: Bool
    @Binding var isTapArchive: Bool
    
    @Binding var isActiveSearch: Bool
    @Binding var isActiveTextSize: Bool
    @Binding var showDeleteAlert: Bool
    
    @Binding var isActiveEnterPassword: Bool
    @Binding var isActiveSetPassword: Bool
    
    @Binding var isPasswordCreated: Bool
    @Binding var showCreatePasswordSheet: Bool
    
    
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
                }.disabled(isTapLock)
                
                Button {
                    notesViewModel.toggleArchive(for: note)
                    isTapArchive.toggle()
                } label: {
                    Image(systemName: isTapArchive ? "archivebox.fill" : "archivebox")
                        .foregroundStyle(isTapArchive ? .blue : .accentColor)
                }.disabled(isTapLock)
                
                Menu {
                    Section {
                        Button {
                            isActiveSearch = true
                        } label: {
                            Text("Search in note")
                            Image(systemName: "magnifyingglass")
                        }.disabled(isTapLock)
                        
                        if !note.isLock {
                            Button {
                                if isPasswordCreated {
                                    isTapLock = true
                                    notesViewModel.toggleLock(for: note)
                                } else {
                                    showCreatePasswordSheet = true
                                }
                            } label: {
                                Text("Set password")
                                Image(systemName: "lock")
                            }
                        } else {
                            Button {
                                if !isTapLock {
                                    notesViewModel.toggleLock(for: note)
                                } else {
                                    isActiveEnterPassword = true
                                }
                            } label: {
                                Text("Delete password")
                                Image(systemName: "lock.open")
                            }
                        }
                    }
                    ShareLink(item: description) {
                        Label("Share a note", systemImage: "square.and.arrow.up")
                    }.disabled(isTapLock)
                    
                    Button {
                        UIPasteboard.general.string = description
                    } label: {
                        Text("Copy text")
                        Image(systemName: "doc.on.doc")
                    }.disabled(isTapLock)
                    
                    Button(role: .destructive) {
                        if !isTapLock {
                            showDeleteAlert = true
                        } else {
                            isActiveEnterPassword = true
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .animation(.bouncy, value: isTapLock)
            .animation(.bouncy, value: isTapArchive)
            .animation(.bouncy, value: isTapLike)
            .font(.system(size: 18))
        }
    }
}


#Preview {
    ContentView()
}
