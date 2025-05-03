import SwiftUI

struct MessageNotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    @Binding var newNote: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            CustomBackgroundView()
            
            VStack(alignment: .leading, spacing: 10) {
      
                ScrollView {
                    CustomTextFieldTitleView(newNote: $newNote, noteExists: $noteExists)
                    
                    CustomTextFieldDescriptionView()
                }
                    
                Spacer()
                
                CustomButtonSaveView(action: {
                    let note = Note(title: newNote, content: "", lastEdited: Date())
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
                            CardRowNotesView(image: "ellipsis.message.fill", text: "Messages", color: .yellow, font: 10)
                        }
                    }
            }
        }
    }
}
