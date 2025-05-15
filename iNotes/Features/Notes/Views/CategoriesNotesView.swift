import SwiftUI

struct CategoriesNotesView: View {
    
    @Binding var isPresented: Bool
    @Binding var noteTitle: String
    @Binding var description: String

    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        VStack {
            TypeNotesView(
                noteTitle: $noteTitle, description: $description,
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
