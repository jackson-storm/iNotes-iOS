import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    var body: some View {
        let activeNotes = notesViewModel.filteredNotes.filter { !$0.isArchive }

        VStack {
            if activeNotes.isEmpty {
                EmptyStateView()
            } else {
                ScrollView {
                    switch selectedDisplayTypeNotes {
                    case .list:
                        NotesCardListView(
                            notes: activeNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    case .grid:
                        NotesCardGridView(
                            notes: activeNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    }
                }
            }
        }
        .background(.backgroundHomePage)
        .animation(.interpolatingSpring, value: isSelectionMode)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "menucard")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No notes available")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.bottom, 50)
    }
}

#Preview {
    ContentView()
}
