import SwiftUI

extension View {
    func noteContextMenu(
        note: Note,
        notesViewModel: NotesViewModel,
        isSelectionMode: Binding<Bool>
    ) -> some View {
        self.contextMenu {
            Section {
                Button {
                    isSelectionMode.wrappedValue = true
                } label: {
                    Label("Select notes", systemImage: "checkmark.circle")
                }
            }

            Button {
                notesViewModel.toggleArchive(for: note)
            } label: {
                Label(note.isArchive ? "Delete from archive" : "Add to archive", systemImage: "archivebox")
            }

            Button(role: .destructive) {
                notesViewModel.delete(note: note)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .disabled(note.isLock)
        }
    }
}

