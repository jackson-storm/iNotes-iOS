import SwiftUI

struct NoteCategoryEditView: View {
    @ObservedObject var notesViewModel: NotesViewModel

    @Binding var noteTitle: String
    @Binding var description: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    @Binding var isPresented: Bool

    let category: NoteCategory
    let categoryIcon: String
    let categoryColor: Color
    let categoryLabel: String

    @State private var isSecretNote = false

    var body: some View {
        ZStack {
            NotesBackgroundView()

            VStack(alignment: .leading, spacing: 10) {
                ScrollView {
                    TextFieldTitleView(noteTitle: $noteTitle, noteExists: $noteExists)

                    TextFieldDescriptionView(description: $description)

                    SecretNotesToggle(isSecret: $isSecretNote)
                }

                Spacer()

                ButtonSaveView(action: {
                    let note = Note(
                        title: noteTitle,
                        description: description,
                        lastEdited: Date(),
                        category: category,
                        isLiked: false,
                        secretNotesEnabled: isSecretNote
                    )
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
                            CardRowNotesView(image: categoryIcon, text: categoryLabel, color: categoryColor, font: 10)
                        }
                    }
            }
        }
    }
}
