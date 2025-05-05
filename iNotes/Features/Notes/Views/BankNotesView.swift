import SwiftUI

struct BankNotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    @Binding var noteTitle: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    @Binding var isPresented: Bool
    @Binding var description: String
    
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
                    let note = Note(title: noteTitle, description: description, lastEdited: Date(), category: .banks)
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
                            CardRowNotesView(image: "dollarsign.bank.building.fill", text: "Bank", color: .red, font: 10)
                        }
                    }
            }
        }
    }
}

