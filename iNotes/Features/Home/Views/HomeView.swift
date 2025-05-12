import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: NoteCategory = .all
    @StateObject private var notesViewModel = NotesViewModel()
    
    @AppStorage("selectedDisplayTypeNotes") private var selectedDisplayTypeNotes: DisplayTypeNotes = .list
    
    @Binding var isSelectionMode: Bool
    @Binding var selectedNotes: Set<UUID>
    
    var body: some View {
        VStack(spacing: 15) {
            if isSelectionMode {
                SelectionOverlayView(
                    isSelectionMode: $isSelectionMode,
                    selectedNotes: $selectedNotes,
                    notesViewModel: notesViewModel
                )
            } else {
                HeaderView(searchBarText: $notesViewModel.searchText)
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
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    notesViewModel: notesViewModel
                )
                .padding(.bottom, 30)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .animation(.bouncy, value: isSelectionMode)
        .padding(.top, 10)
        .background(Color.backgroundHomePage)
        .onAppear {
            notesViewModel.filterNotes(by: selectedCategory)
        }
        .onChange(of: selectedCategory) { newValue,_ in
            notesViewModel.filterNotes(by: newValue)
        }
    }
}

struct SelectionOverlayView: View {
    @Binding var isSelectionMode: Bool
    @Binding var selectedNotes: Set<UUID>
    @ObservedObject var notesViewModel: NotesViewModel

    var body: some View {
        if isSelectionMode {
            HStack {
                Button("Cancel") {
                    selectedNotes.removeAll()
                    isSelectionMode = false
                }
                Spacer()
                Text("Selected: \(selectedNotes.count)")
                    .foregroundColor(.gray)
                Spacer()
                Button("Delete") {
                    notesViewModel.delete(notesWithIDs: selectedNotes)
                    selectedNotes.removeAll()
                    isSelectionMode = false
                }
                .foregroundColor(.red)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(.backgroundHomePage)
        }
    }
}

#Preview {
    ContentView()
}
