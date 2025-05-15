import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: NoteCategory = .all
    @StateObject private var notesViewModel = NotesViewModel()
    
    @AppStorage("selectedDisplayTypeNotes") private var selectedDisplayTypeNotes: DisplayTypeNotes = .list
    
    @Binding var isSelectionMode: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var sortType: NotesSortType
    
    var body: some View {
        VStack(spacing: 15) {
            if isSelectionMode {
                SelectionOverlayView(
                    isSelectionMode: $isSelectionMode,
                    selectedNotes: $selectedNotes,
                    notesViewModel: notesViewModel
                )
            } else {
                HeaderView(
                    searchBarText: $notesViewModel.searchText,
                    isSelectionMode: $isSelectionMode,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    sortType: $notesViewModel.sortType
                )
            }
            
            HorizontalFilterView(notesViewModel: notesViewModel)
            
            ZStack(alignment: .bottom) {
                NotesListView(
                    notesViewModel: notesViewModel,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    selectedNotes: $selectedNotes,
                    isSelectionMode: $isSelectionMode
                )
                
                HomeCustomTabView(
                    selectedNotes: $selectedNotes,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    isSelectionMode: $isSelectionMode,
                    notesViewModel: notesViewModel
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .animation(.bouncy, value: isSelectionMode)
        .background(Color.backgroundHomePage)
        .onAppear {
            notesViewModel.filterNotes(by: selectedCategory)
        }
        .onChange(of: selectedCategory) { newValue,_ in
            notesViewModel.filterNotes(by: newValue)
        }
    }
}

#Preview {
    ContentView()
}
