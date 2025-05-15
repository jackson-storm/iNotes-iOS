import SwiftUI

extension View {
    func noteContextMenu(
        note: Note,
        notesViewModel: NotesViewModel,
        isSelectionMode: Binding<Bool>
    ) -> some View {
        self.contextMenu {
            Button {
                isSelectionMode.wrappedValue = true
            } label: {
                Label("Select notes", systemImage: "checkmark.circle")
            }

            Button {
               
            } label: {
                Label("Add to archive", systemImage: "archivebox")
            }

            Button(role: .destructive) {
                notesViewModel.delete(note: note)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
