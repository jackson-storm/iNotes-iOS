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
    @Binding var selectedTheme: Theme
    @Binding var selectedTintRawValue: String
    
    var body: some View {
        VStack(spacing: 15) {
            if isSelectionMode && selectedTab != 2 {
                SelectionOverlayView (
                    isSelectionMode: $isSelectionMode,
                    selectedNotes: $selectedNotes,
                    notesViewModel: notesViewModel
                )
            } else if selectedTab != 2 {
                HeaderView (
                    searchBarText: $notesViewModel.searchText,
                    isSelectionMode: $isSelectionMode,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    sortType: $notesViewModel.sortType, selectedTab: $selectedTab, isSheetPresented: $isSheetPresented
                )
                .padding(.top, 10)
            }
            if selectedTab != 2 {
                HorizontalFilterView(notesViewModel: notesViewModel)
            }
            
            ZStack(alignment: .bottom) {
                HomeCustomTabView (
                    isSheetPresented: $isSheetPresented, selectedNotes: $selectedNotes,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    isSelectionMode: $isSelectionMode, selectedTab: $selectedTab, selectedTheme: $selectedTheme, selectedTintRawValue: $selectedTintRawValue,
                    notesViewModel: notesViewModel
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .preferredColorScheme(selectedTheme.colorScheme)
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
