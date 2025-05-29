import SwiftUI

struct NoteCategoryEditView: View {
    @AppStorage("textScale") private var textScale: Double = 100

    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss

    @Binding var noteTitle: String
    @Binding var description: String
    @Binding var isPresented: Bool

    let category: NoteCategory
    let categoryIcon: String
    let categoryColor: Color
    let categoryLabel: String

    @State private var isSecretNote = false
    @State private var searchTextEditNotes: String = ""
    @State private var isActiveSearch: Bool = false
    @State private var isActiveTextSize: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            SearchBarSection(
                isActiveSearch: $isActiveSearch,
                searchTextEditNotes: $searchTextEditNotes,
                description: $description,
                matchRanges: $notesViewModel.matchRanges,
                currentMatchIndex: $notesViewModel.currentMatchIndex
            )

            TextSizeSection(
                isActiveTextSize: $isActiveTextSize,
                textScale: $textScale
            )

            NoteHeaderSection(
                title: $noteTitle,
                lastEdited: Date()
            )

            NoteEditorSection(
                description: $description,
                searchText: searchTextEditNotes,
                currentMatchIndex: notesViewModel.currentMatchIndex,
                matchRanges: notesViewModel.matchRanges,
                fontSize: textScale
            )
        }
        .animation(.bouncy, value: isActiveSearch)
        .animation(.bouncy, value: isActiveTextSize)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.backgroundHomePage)
        .toolbar {
            ToolbarItem(placement: .principal) {
                CardRowNotesView(
                    image: categoryIcon,
                    text: categoryLabel,
                    color: categoryColor,
                    font: 10
                )
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Create") {
                    let note = Note(
                        title: noteTitle,
                        description: description,
                        lastEdited: Date(),
                        category: category,
                        isLiked: false,
                        secretNotesEnabled: isSecretNote
                    )
                    if notesViewModel.addNoteIfNotExists(note) {
                        noteTitle = ""
                        description = ""
                        isSecretNote = false
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
