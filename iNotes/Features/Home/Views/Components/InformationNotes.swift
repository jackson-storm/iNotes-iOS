import SwiftUI

struct InformationNotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Label {
                Text("\(notesViewModel.selectedCategory.rawValue.capitalized): \(notesViewModel.filteredNotes.count) notes")
            } icon: {
                Image(systemName: notesViewModel.selectedCategory.icon)
            }
            .font(.system(size: 16))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
