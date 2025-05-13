import SwiftUI

struct EditNotesView: View {
    let note: Note
    
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var description: String
    @State private var title: String
    @State private var isTap: Bool
    @State private var showDeleteAlert = false
    
    init(note: Note, notesViewModel: NotesViewModel) {
        self.note = note
        self.notesViewModel = notesViewModel
        
        _description = State(initialValue: note.description)
        _title = State(initialValue: note.title)
        let stored = UserDefaults.standard.bool(forKey: "isLiked_\(note.id.uuidString)")
        _isTap = State(initialValue: stored)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Title", text: $title)
                    .bold()
                    .font(.system(size: 22))
                    .padding(.horizontal)
                    .padding(.top)
                
                Text(note.lastEdited.formatted(date: .abbreviated, time: .shortened))
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.trailing)
                    .padding(.top)
            }
            
                TextEditor(text: $description)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(Color.backgroundHomePage)
            
        }
        .background(Color.backgroundHomePage.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Menu {
                    Button {
                        notesViewModel.toggleLike(for: note)
                        isTap.toggle()
                    } label: {
                        Text("Like")
                        Image(systemName: isTap ? "heart.fill" : "heart")
                            .foregroundStyle(isTap ? .red : .primary)
                    }
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Delete note?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                notesViewModel.delete(note: note)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .onChange(of: title) { newTitle, _ in
            notesViewModel.update(noteID: note.id, title: newTitle, description: description)
        }
        .onChange(of: description) { newDescription, _ in
            notesViewModel.update(noteID: note.id, title: title, description: newDescription)
        }
    }
}

#Preview {
    ContentView()
}
