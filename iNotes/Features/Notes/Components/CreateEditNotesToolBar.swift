import SwiftUI

struct CreateEditNotesToolbar: ToolbarContent {
    let note: Note
    
    @Binding var title: String
    @Binding var description: String
    
    @Binding var isTapLike: Bool
    @Binding var isTapArchive: Bool
    @Binding var isPresented: Bool
    
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
                
                Button {
                    if notesViewModel.addNoteIfNotExists(note) {
                        isPresented = false
                    }
                } label: {
                    Text("Create")
                        .bold()
                }
            }
            .font(.system(size: 18))
        }
    }
}
