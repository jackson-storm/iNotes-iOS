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
    @Binding var deleteActionType: DeleteActionType?
    
    @State private var noteTitle = ""
    @State private var description = ""

    var body: some View {
        VStack(spacing: 0) {
            if selectedTab == 1 {
                VStack(spacing: 10) {
                    HeaderView(
                        searchBarText: $notesViewModel.searchText,
                        isSelectionMode: $isSelectionMode,
                        selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                        sortType: $notesViewModel.sortType,
                        selectedTab: $selectedTab,
                        isSheetPresented: $isSheetPresented,
                        deleteActionType: $deleteActionType,
                        selectedNotes: $selectedNotes,
                        notesViewModel: notesViewModel
                    )
                    .padding(.horizontal)
                    
                    HorizontalFilterView(notesViewModel: notesViewModel)
                }
                .background(.backgroundComponents.opacity(0.9))
            }

            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case 0:
                        ArchiveContentView (
                            notes: notesViewModel.filteredNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode,
                            selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                            deleteActionType: $deleteActionType
                        )
                    case 1:
                        NotesListView (
                            notesViewModel: notesViewModel,
                            selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    case 2:
                        SettingsView (
                            selectedTheme: $selectedTheme,
                            selectedTintRawValue: $selectedTintRawValue
                        )
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)

                CustomTabBar(
                    selectedTab: $selectedTab,
                    isSheetPresented: $isSheetPresented,
                    isSelectionMode: $isSelectionMode
                )
                .background(Color.backgroundHomePage.shadow(color: .gray, radius: 0.5))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .preferredColorScheme(selectedTheme.colorScheme)
        .animation(.bouncy, value: isSelectionMode)
        .background(Color.backgroundHomePage.ignoresSafeArea())
        .onAppear {
            notesViewModel.filterNotes(by: selectedCategory)
        }
        .onChange(of: selectedCategory) { newValue,_ in
            notesViewModel.filterNotes(by: newValue)
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                CategoriesNotesView(
                    isPresented: $isSheetPresented,
                    noteTitle: $noteTitle,
                    description: $description,
                    viewModel: notesViewModel
                )
            }
            .presentationBackground(Color.backgroundHomePage)
        }
    }
}

#Preview {
    ContentView()
}
