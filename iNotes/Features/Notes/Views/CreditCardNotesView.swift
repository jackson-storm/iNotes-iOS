import SwiftUI

struct CreditCardNotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    @Binding var newNote: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.backgroundHomePage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                ScrollView {
                    CustomTextFieldTitle(newNote: $newNote, noteExists: $noteExists)
                    
                    CustomTextFieldDescriptionView()
                }
                Spacer()
                
                CustomButtonSave(action: {
                    if notesViewModel.addNoteIfNotExists(newNote) {
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
                            CardRowNotesView(image: "creditcard.fill", text: "Credit Card", color: .green)
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
