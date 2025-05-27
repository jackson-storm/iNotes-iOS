import SwiftUI

struct ArchiveContentView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel
    
    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var deleteActionType: DeleteActionType?
    
    var body: some View {
        NavigationStack {
            let archivedNotes = notes.filter { $0.isArchive }
            if archivedNotes.isEmpty {
                EmptyStateArchiveView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(archivedNotes) { note in
                            Group {
                                if isSelectionMode {
                                    ArchiveCardView(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
                                } else {
                                    NavigationLink(destination: EditNotesView(note: note, notesViewModel: notesViewModel)) {
                                        ArchiveCardView(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .onTapGesture {
                                if isSelectionMode {
                                    if selectedNotes.contains(note.id) {
                                        selectedNotes.remove(note.id)
                                    } else {
                                        selectedNotes.insert(note.id)
                                    }
                                }
                            }
                            .foregroundStyle(.primary)
                            .noteContextMenu(
                                note: note,
                                notesViewModel: notesViewModel,
                                isSelectionMode: $isSelectionMode
                            )
                        }
                    }
                }
                .animation(.bouncy, value: archivedNotes.count)
            }
        }
        .navigationTitle(
            isSelectionMode ? Text("Selected: \(selectedNotes.count)") : Text("Archive")
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.backgroundComponents.opacity(0.6), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if isSelectionMode {
                    Button("Cancel") {
                        selectedNotes.removeAll()
                        isSelectionMode = false
                    }
                } else {
                    Button("Edit") {
                        isSelectionMode = true
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if isSelectionMode {
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
                } else {
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
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

#Preview {
    ContentView()
}
