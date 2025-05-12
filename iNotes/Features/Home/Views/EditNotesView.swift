import SwiftUI

struct EditNotesView: View {
    let note: Note
    
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var description: String
    @State private var title: String
    @State private var isTap: Bool
    @State private var showDeleteAlert = false
    
    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        
        _description = State(initialValue: note.description)
        _title = State(initialValue: note.title)
        let stored = UserDefaults.standard.bool(forKey: "isLiked_\(note.id.uuidString)")
        _isTap = State(initialValue: stored)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundLayer
            
            VStack(spacing: 0) {
                topBar
                textEditorSection
            }
        }
        .navigationBarBackButtonHidden(true)
        .font(.system(size: 18))
        .foregroundStyle(.primary)
    }
    
    private var backgroundLayer: some View {
        Color.backgroundHomePage
            .ignoresSafeArea()
    }
    
    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.primary)
                    .padding(.vertical, 20)
                    .padding(.leading, 15)
                    .font(.system(size: 20))
            }
            
            TextField("Title", text: $title)
                .bold()
                .font(.system(size: 22))
                .padding(.leading, 8)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.update(noteID: note.id, title: title, description: description)
                    dismiss()
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
                
                Button(action: {
                    viewModel.toggleLike(for: note)
                    isTap.toggle()
                }) {
                    Image(systemName: isTap ? "heart.fill" : "heart")
                        .foregroundStyle(isTap ? .red : .primary)
                }
                
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                }
                .alert("Delete note?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        viewModel.delete(note: note)
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This action cannot be undone.")
                }
            }
            .font(.system(size: 20))
            .padding()
        }
        .background(Color.backgroundHomePage)
    }
    
    private var textEditorSection: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $description)
                .scrollContentBackground(.hidden)
                .padding(10)
                .padding(.bottom, 5)
                .background(.backgroundComponents)
        }
    }
}

#Preview {
    ContentView()
}
