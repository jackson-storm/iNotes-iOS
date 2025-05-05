import SwiftUI

struct CategoriesNotesView: View {
    
    @Binding var isPresented: Bool
    @Binding var noteTitle: String
    @Binding var description: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool

    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        VStack {
            TypeNotesView(
                noteTitle: $noteTitle, description: $description,
                noteExists: $noteExists,
                showNoteExists: $showNoteExists,
                isPresented: $isPresented,
                viewModel: viewModel
            )
            Spacer()
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
