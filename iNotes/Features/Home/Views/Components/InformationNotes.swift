import SwiftUI

struct InformationNotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        HStack() {
            Label {
                Text("\(notesViewModel.selectedCategory.rawValue.capitalized): \(notesViewModel.filteredNotes.count) notes")
            } icon: {
                Image(systemName: notesViewModel.selectedCategory.icon)
            }
            .font(.system(size: 15))
            .foregroundStyle(.secondary.opacity(0.8))
            .padding(8)
            
            Spacer()
        }
        .background(.backgroundComponents.opacity(0.8))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}
