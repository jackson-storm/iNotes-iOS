import SwiftUI

struct AddNoteView: View {
    @Binding var isPresented: Bool
    @State private var newNote: String = ""
    @State private var showNoteExists: Bool = false
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomTextFieldAddNotesView(newNote: $newNote, noteExists: $showNoteExists)
                
                Spacer()
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
                            if viewModel.noteExists(newNote) {
                                showNoteExists = true
                            } else {
                                viewModel.notes.append(newNote)
                                viewModel.saveNotes()
                                isPresented = false
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView()
}
