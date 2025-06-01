import SwiftUI

struct NoteCategoryEditView: View {
    @AppStorage("textScale") private var textScale: Double = 100

    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss

    @Binding var noteTitle: String
    @Binding var description: String
    @Binding var isPresented: Bool
    @Binding var isSaved: Bool

    @State private var selectedCategory: NoteCategory = .all
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
                title: $noteTitle, isSaved: $isSaved,
                lastEdited: Date()
            )
            
            Spacer()
        }
        .animation(.bouncy, value: isActiveSearch)
        .animation(.bouncy, value: isActiveTextSize)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.backgroundHomePage)
        .navigationTitle("Create Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    isPresented = false
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .principal) {
                Menu {
                    ForEach(NoteCategory.allCases, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Label(category.rawValue.capitalized, systemImage: category.iconMenu)
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(selectedCategory.color)
                                .frame(width: 26, height: 26)
                            
                            Image(systemName: selectedCategory.icon)
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                        }
                        Text(selectedCategory.rawValue.capitalized)
                            .foregroundColor(.primary)
                            .bold()
                        
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Create") {
                    let note = Note(
                        title: noteTitle,
                        description: description,
                        lastEdited: Date(),
                        category: selectedCategory,
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
