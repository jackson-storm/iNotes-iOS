import SwiftUI

struct AddNoteView: View {
    @Binding var isPresented: Bool
    
    @State private var newNote: String = ""
    @State private var showNoteExists: Bool = false
    
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
            VStack {
                TypeNotesView()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Add Notes")
                        .bold()
                }
                
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        if !newNote.isEmpty {
//                            if viewModel.noteExists(newNote) {
//                                showNoteExists = true
//                            } else {
//                                viewModel.notes.append(newNote)
//                                viewModel.saveNotes()
//                                isPresented = false
//                            }
//                        }
//                    }
//                }
            }
    }
}


#Preview {
    AddNoteView(isPresented: .constant(true), viewModel: NotesViewModel())
}
