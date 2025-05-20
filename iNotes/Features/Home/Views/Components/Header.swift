import SwiftUI

struct HeaderView: View {
    @Binding var searchBarText: String
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var sortType: NotesSortType
    @Binding var selectedTab: Int
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            if selectedTab == 1 {
                if searchBarText.isEmpty {
                    HeaderButtonMenuView(
                        isSelectionMode: $isSelectionMode,
                        selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                        sortType: $sortType
                    )
                }
            }
            
            SearchBarHomeView(searchText: $searchBarText, selectedTab: $selectedTab)
            
            if selectedTab == 1 {
                if searchBarText.isEmpty {
                    HeaderAddNotesView(isSheetPresented: $isSheetPresented)
                }
            }
        }
        .animation(.bouncy(duration: 0.5), value: searchBarText)
        .padding(.horizontal, selectedTab == 1 ? 15 : 20)
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
                .padding(5)
                .contentShape(Rectangle())
                .font(.system(size: 24))
        }
    }
}

#Preview {
    ContentView()
}
