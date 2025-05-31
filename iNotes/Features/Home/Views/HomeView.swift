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
    @Binding var isSaved: Bool
    
    @State private var noteTitle = ""
    @State private var description = ""
    
    @State private var showToast = false
    @State private var toastMessage = ""

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
                    .padding(.top, 10)
                    
                    HorizontalFilterView(notesViewModel: notesViewModel)
                }
                .background(.backgroundComponents.opacity(0.8))
                
                //InformationNotesView(notesViewModel: notesViewModel)
            }

            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case 0:
                        ArchiveContentView(
                            notes: notesViewModel.filteredNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode,
                            selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                            deleteActionType: $deleteActionType,
                            searchText: $notesViewModel.searchText,
                            selectedTab: $selectedTab
                        )
                    case 1:
                        NotesListView(
                            notesViewModel: notesViewModel,
                            selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    case 2:
                        SettingsView(
                            selectedTheme: $selectedTheme,
                            selectedTintRawValue: $selectedTintRawValue
                        )
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
            }
        }
        .animation(.bouncy, value: selectedTab)
        .toolbarBackground(.backgroundComponents.opacity(0.8), for: .bottomBar)
        .toolbarBackgroundVisibility(.visible, for: .bottomBar)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                CustomTabView(
                    notesViewModel: notesViewModel,
                    selectedTab: $selectedTab,
                    isSelectionMode: $isSelectionMode,
                    selectedNotes: $selectedNotes,
                    deleteActionType: $deleteActionType
                )
            }
        }
        .preferredColorScheme(selectedTheme.colorScheme)
        .animation(.interpolatingSpring, value: isSelectionMode)
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
                    isSaved: $isSaved,
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
