import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: NoteCategory = .all
    @StateObject private var notesViewModel = NotesViewModel()
    
    @AppStorage("selectedDisplayTypeNotes") private var selectedDisplayTypeNotes: DisplayTypeNotes = .list
    
    @Binding var isSelectionMode: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var sortType: NotesSortType
    @Binding var selectedTab: Int
    @Binding var isSheetPresented: Bool
    
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
                    sortType: $notesViewModel.sortType, selectedTab: $selectedTab, isSheetPresented: $isSheetPresented
                )
            }
            if selectedTab == 1 {
                HorizontalFilterView(notesViewModel: notesViewModel)
            }
            
            ZStack(alignment: .bottom) {
                HomeCustomTabView(
                    isSheetPresented: $isSheetPresented, selectedNotes: $selectedNotes,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    isSelectionMode: $isSelectionMode, selectedTab: $selectedTab,
                    notesViewModel: notesViewModel
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .padding(.top, 10)
        .animation(.bouncy, value: selectedTab)
        .animation(.bouncy, value: isSelectionMode)
        .background(Color.backgroundHomePage.ignoresSafeArea())
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
