import SwiftUI

struct HomeCustomTabView: View {
    @State private var noteTitle = ""
    @State private var description = ""

    @Binding var isSheetPresented: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var isSelectionMode: Bool
    @Binding var selectedTab: Int
    @Binding var selectedTheme: Theme
    @Binding var selectedTintRawValue: String
    
    @ObservedObject var notesViewModel: NotesViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    ArchiveContentView (
                        notes: notesViewModel.filteredNotes,
                        notesViewModel: notesViewModel,
                        selectedNotes: $selectedNotes,
                        isSelectionMode: $isSelectionMode, selectedDisplayTypeNotes: $selectedDisplayTypeNotes
                    )
                        .transition(.opacity)
                case 1:
                    NotesListView (
                        notesViewModel: notesViewModel,
                        selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                        selectedNotes: $selectedNotes,
                        isSelectionMode: $isSelectionMode
                    )
                    .transition(.opacity)
                case 2:
                    SettingsView (
                        selectedTheme: $selectedTheme,
                        selectedTintRawValue: $selectedTintRawValue
                    )
                        .transition(.opacity)
                default:
                    EmptyView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab, isSheetPresented: $isSheetPresented, isSelectionMode: $isSelectionMode)
                .background(Color.backgroundHomePage.shadow(radius: 1))
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

private struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var isSheetPresented: Bool
    @Binding var isSelectionMode: Bool
    
    var body: some View {
        HStack {
            TabBarButton(icon: (selectedTab != 0) ? "archivebox" : "archivebox.fill", title: "Archive", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())

            TabBarButton(icon: (selectedTab != 1) ? "note" : "note.text", title: "Notes", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .contextMenu {
                Button {
                    isSheetPresented = true
                } label: {
                    Label("Add note", systemImage: "plus")
                }
                Button {
                    isSelectionMode = true
                } label: {
                    Label("Select notes", systemImage: "checkmark.circle")
                }
            }

            TabBarButton(icon: (selectedTab != 2) ? "gearshape" : "gearshape.fill", title: "Settings", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .padding(.bottom, 28)
        .padding(.horizontal, 10)
        .background(Color.backgroundComponents)
    }
}

private struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .accentColor : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .accentColor : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ContentView()
}
