import SwiftUI

struct HeaderView: View {
    @Binding var searchBarText: String
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    
    var body: some View {
        HStack(spacing: 15) {
            if searchBarText.isEmpty {
                HeaderProfileImage()
            }
            
            SearchBarHomeView(searchText: $searchBarText)
            
            if searchBarText.isEmpty {
                HeaderButtonMenuView(isSelectionMode: $isSelectionMode, selectedDisplayTypeNotes:
                $selectedDisplayTypeNotes)
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
    
    var body: some View {
        VStack {
            Menu {
                Button(action: {
                    isSelectionMode = true
                }) {
                    Label("Select notes", systemImage: "checkmark.circle")
                }
                
                Menu {
                    Button(action: {
                        selectedDisplayTypeNotes = .list
                    }) {
                       Text("List")
                    }
                    Button(action: {
                        selectedDisplayTypeNotes = .grid
                    }) {
                       Text("Grid")
                    }
                } label: {
                    Label("Display notes", systemImage: selectedDisplayTypeNotes.iconName)
                }

                Menu {
                    Button(action: {
                        
                    }) {
                        Text("По умолчанию (дата изменения)")
                    }
                } label: {
                    Label("Sorting notes", systemImage: "arrow.up.arrow.down")
                }

                Menu {
                    Button(action: {
                        
                    }) {
                        Text("По умолчанию (включено)")
                    }
                } label: {
                    Label("Group by date", systemImage: "calendar")
                }

                Button(action: {
                   
                }) {
                    Label("Просмотреть вложения", systemImage: "paperclip")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 24))
            }
        }
    }
}

#Preview {
    ContentView()
}
