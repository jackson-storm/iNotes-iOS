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
        .navigationTitle(Text("Categories"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.backgroundComponents.opacity(0.6), for: .navigationBar)
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
