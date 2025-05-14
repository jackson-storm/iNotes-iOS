import SwiftUI

struct HeaderView: View {
    @Binding var searchBarText: String
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var sortType: NotesSortType
    
    var body: some View {
        HStack(spacing: 15) {
            if searchBarText.isEmpty {
                HeaderProfileImage()
            }
            
            SearchBarHomeView(searchText: $searchBarText)
            
            if searchBarText.isEmpty {
                HeaderButtonMenuView(
                    isSelectionMode: $isSelectionMode,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    sortType: $sortType
                )
            }
        }
        .animation(.bouncy(duration: 0.5), value: searchBarText)
        .padding(.horizontal, 20)
    }
}

private struct HeaderProfileImage: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
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
            Button(action: {
                isSelectionMode = true
            }) {
                Label("Select notes", systemImage: "checkmark.circle")
            }

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
                .font(.system(size: 24))
        }
    }
}

#Preview {
    ContentView()
}
