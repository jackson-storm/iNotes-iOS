import SwiftUI

struct SelectionOverlayView: View {
    @Binding var isSelectionMode: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var deleteActionType: DeleteActionType?
    
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        if isSelectionMode {
            HStack {
                Button("Cancel") {
                    selectedNotes.removeAll()
                    isSelectionMode = false
                }
                Spacer()
                
                Text("Selected: \(selectedNotes.count)")
                    .foregroundColor(.primary)
                    .bold()
                
                Spacer()
                if selectedNotes.count > 0 {
                    Button("Delete") {
                        deleteActionType = .deleteSelected
                    }
                    .foregroundColor(.red)
                } else {
                    Button("Delete all") {
                        deleteActionType = .deleteAll
                    }
                    .foregroundColor(.red)
                }
            }
            .padding(.vertical, 5)
            .actionSheet(item: $deleteActionType) { actionType in
                switch actionType {
                case .deleteAll:
                    return ActionSheet(
                        title: Text("Delete notes?"),
                        message: Text("This action is irreversible."),
                        buttons: [
                            .destructive(Text("Delete all notes")) {
                                notesViewModel.deleteAllNotes()
                                isSelectionMode = false
                            },
                            .cancel()
                        ]
                    )
                case .deleteSelected:
                    return ActionSheet(
                        title: Text("Delete selected notes?"),
                        message: Text("This action is irreversible."),
                        buttons: [
                            .destructive(Text("Delete \(selectedNotes.count) notes")) {
                                notesViewModel.delete(notesWithIDs: selectedNotes)
                                selectedNotes.removeAll()
                                isSelectionMode = false
                            },
                            .cancel()
                        ]
                    )
                }
            }
        }
    }
}
