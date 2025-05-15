import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    var body: some View {
        VStack {
            if notesViewModel.filteredNotes.isEmpty {
                EmptyStateView()
            } else {
                ScrollView {
                    InformationNotesView(notesViewModel: notesViewModel)
                    
                    switch selectedDisplayTypeNotes {
                    case .list:
                        NotesCardListView(
                            notes: notesViewModel.filteredNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    case .grid:
                        NotesCardGridView(
                            notes: notesViewModel.filteredNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    }
                }
            }
        }
        .animation(.bouncy, value: selectedDisplayTypeNotes)
        .animation(.bouncy, value: notesViewModel.filteredNotes.count)
    }
}

private struct EmptyStateView: View {
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

