import SwiftUI

struct HomeCustomTabView: View {
    @State private var isSheetPresented = false
    @State private var noteTitle = ""
    @State private var description = ""
    @State private var selectedTab: Int = 0

    @Binding var selectedNotes: Set<UUID>
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var isSelectionMode: Bool

    @ObservedObject var notesViewModel: NotesViewModel


    var body: some View {
        TabView(selection: $selectedTab) {
            NotesListView(
                notesViewModel: notesViewModel,
                selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                selectedNotes: $selectedNotes,
                isSelectionMode: $isSelectionMode
            )
            .tabItem {
                Label("Notes", systemImage: "note.text")
            }
            .tag(0)

            Color.clear
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
                .tag(1)
                .onAppear {
                    if selectedTab == 1 {
                        selectedTab = 0
                    }
                }

            Text("Settings View")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .onChange(of: selectedTab) { newValue, _ in
            if newValue == 1 {
                isSheetPresented = true
                selectedTab = 0
            }
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
