import SwiftUI

struct AddNoteView: View {
    @Binding var isPresented: Bool
    @State private var newNote: String = ""
    @ObservedObject var viewModel = NotesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarAddNotesView()
                
            }
        }
        .padding(.horizontal, 20)
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresented = false
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Add Note")
                    .font(.headline)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if !newNote.isEmpty {
                        viewModel.notes.append(newNote)
                        viewModel.saveNotes()
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView()
}
