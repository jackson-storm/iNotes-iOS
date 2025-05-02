import SwiftUI

struct CategoriesNotesView: View {
    @Binding var isPresented: Bool
    @Binding var newNote: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        VStack {
            TypeNotesView(
                newNote: $newNote,
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
