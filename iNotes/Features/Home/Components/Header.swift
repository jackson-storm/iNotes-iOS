import SwiftUI

struct HeaderView: View {
    @Binding var searchBarText: String
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var sortType: NotesSortType
    @Binding var selectedTab: Int
    @Binding var isSheetPresented: Bool
    
    @Binding var deleteActionType: DeleteActionType?
    @Binding var selectedNotes: Set<UUID>
    
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            if !isSelectionMode {
                if searchBarText.isEmpty {
                    HeaderButtonMenuView(
                        isSelectionMode: $isSelectionMode,
                        selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                        sortType: $sortType
                    )
                }
            } else {
                Button("Cancel") {
                    selectedNotes.removeAll()
                    isSelectionMode = false
                }
            }
            
            SearchBarHomeView(searchText: $searchBarText, selectedTab: $selectedTab)
            
            if searchBarText.isEmpty {
                HeaderAddNotesView(isSheetPresented: $isSheetPresented)
                    .disabled(isSelectionMode)
            }
        }
        .animation(.bouncy(duration: 0.5), value: searchBarText)
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

private struct HeaderAddNotesView: View {
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isSheetPresented = true
            }) {
                Image(systemName: "plus.circle")
                    .padding(5)
                    .contentShape(Rectangle())
                    .font(.system(size: 24, weight: .light))
            }
            
        }
    }
}

private struct HeaderButtonMenuView: View {
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var sortType: NotesSortType
    
    var body: some View {
        Menu {
            ///select notes
            Button {
                isSelectionMode = true
            } label: {
                Label("Select notes", systemImage: "checkmark.circle")
            }
            ///display notes
            Menu {
                Button {
                    selectedDisplayTypeNotes = .list
                } label: {
                    Label("List", systemImage: selectedDisplayTypeNotes == .list ? "checkmark" : "")
                }
                Button {
                    selectedDisplayTypeNotes = .grid
                } label: {
                    Label("Grid", systemImage: selectedDisplayTypeNotes == .grid ? "checkmark" : "")
                }
            } label: {
                Label("Display notes", systemImage: selectedDisplayTypeNotes.iconName)
            }
            ///sorting
            Menu {
                Button {
                    sortType = .creationDate
                } label: {
                    Label("Creation date", systemImage: sortType == .creationDate ? "checkmark" : "")
                }
                Button {
                    sortType = .lastModified
                } label: {
                    Label("Date modified", systemImage: sortType == .lastModified ? "checkmark" : "")
                }
                Button {
                    sortType = .name
                } label: {
                    Label("Name", systemImage: sortType == .name ? "checkmark" : "")
                }
            } label: {
                Label("Sorting notes", systemImage: "arrow.up.arrow.down")
            }
            
        } label: {
            Image(systemName: "ellipsis.circle")
                .padding(5)
                .contentShape(Rectangle())
                .font(.system(size: 24, weight: .light))
        }
        
    }
}

#Preview {
    ContentView()
}
