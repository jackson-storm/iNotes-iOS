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

private struct SearchBarAddNotesView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundSearchBar)
                .frame(height: 45)
            
            if searchText.isEmpty {
                Text("Notes title")
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
            }
            
            HStack {
                TextField("", text: $searchText)
                    .foregroundColor(.primary)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .animation(.bouncy, value: searchText)
            .padding(.horizontal, 15)
        }
    }
}


#Preview {
    HomePageView()
}
