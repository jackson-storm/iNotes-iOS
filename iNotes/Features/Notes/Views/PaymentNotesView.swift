import SwiftUI

struct PaymentNotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    @Binding var noteTitle: String
    @Binding var description: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    @Binding var isPresented: Bool
    
    
    
    var body: some View {
        ZStack {
            NotesBackgroundView()
            
            VStack(alignment: .leading, spacing: 10) {
                
                ScrollView {
                    TextFieldTitleView(noteTitle: $noteTitle, noteExists: $noteExists)
                    
                    TextFieldDescriptionView(description: $description)
                }
                
                Spacer()
                
                ButtonSaveView(action: {
                    let note = Note(title: noteTitle, description: description, lastEdited: Date())
                    if notesViewModel.addNoteIfNotExists(note) {
                        isPresented = false
                    } else {
                        withAnimation {
                            noteExists = true
                        }
                    }
                })
            }
            .safeAreaInset(edge: .top) {
                Spacer()
                    .frame(height: 20)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            CardRowNotesView(image: "banknote.fill", text: "Payments", color: .blue, font: 10)
                        }
                    }
            }
        }
    }
}
