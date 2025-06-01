import SwiftUI

struct HeaderView: View {
    @Binding var searchBarText: String
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var sortType: NotesSortType
    @Binding var selectedTab: Int
    @Binding var isSheetAddNotesPresented: Bool
    
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
            
            if !isSelectionMode {
                if searchBarText.isEmpty {
                    HeaderAddNotesView(isSheetAddNotesPresented: $isSheetAddNotesPresented)
                }
            } else {
                ZStack {
                    Circle()
                        
                        .stroke(Color.accentColor, lineWidth: 1)
                        .frame(width: 38, height: 25)
                    
                    Text(selectedNotes.count.description)
                        .foregroundStyle(.white)
                }
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
    @Binding var isSheetAddNotesPresented: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isSheetAddNotesPresented = true
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
            Section {
                Button {
                    isSelectionMode = true
                } label: {
                    Label("Select notes", systemImage: "checkmark.circle")
                }
            }
            ///display notes
            Menu {
                Button {
                    selectedDisplayTypeNotes = .List
                } label: {
                    Label("List", systemImage: selectedDisplayTypeNotes == .List ? "checkmark" : "")
                }
                Button {
                    selectedDisplayTypeNotes = .Grid
                } label: {
                    Label("Grid", systemImage: selectedDisplayTypeNotes == .Grid ? "checkmark" : "")
                }
            } label: {
                Label("Display notes", systemImage: selectedDisplayTypeNotes.iconName)
                Text(selectedDisplayTypeNotes.rawValue)
            }
            ///sorting
            Menu {
                Button {
                    sortType = .CreationDate
                } label: {
                    Label("Creation date", systemImage: sortType == .CreationDate ? "checkmark" : "")
                }
                Button {
                    sortType = .LastModified
                } label: {
                    Label("Date modified", systemImage: sortType == .LastModified ? "checkmark" : "")
                }
                Button {
                    sortType = .Name
                } label: {
                    Label("Name", systemImage: sortType == .Name ? "checkmark" : "")
                }
            } label: {
                Label("Sorting notes", systemImage: "arrow.up.arrow.down")
                Text(sortType.rawValue)
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
