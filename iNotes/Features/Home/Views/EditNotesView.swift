import SwiftUI

struct EditNotesView: View {
    let note: Note
    
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var description: String
    @State private var title: String
    @State private var isTap: Bool
    
    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        
        let key = "isLiked_\(note.id.uuidString)"
        let stored = UserDefaults.standard.bool(forKey: key)
        
        _description = State(initialValue: note.description)
        _title = State(initialValue: note.title)
        _isTap = State(initialValue: stored)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.backgroundHomePage)
                    .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $description)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 10)
                        .padding(.top, 65)
                        .padding(.bottom, 5)
                }
            }
            
            HStack {
                Button(action: {dismiss()}) {
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
                    Button(action: {}) {
                        Image(systemName: "archivebox")
                    }
                    
                    Button(action: {
                        isTap.toggle()
                        let key = "isLiked_\(note.id.uuidString)"
                        UserDefaults.standard.set(isTap, forKey: key)
                        
                        if let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) {
                            viewModel.notes[index].isLiked = isTap
                            viewModel.filterNotes(by: viewModel.selectedCategory)
                        }
                    }) {
                        Image(systemName: isTap ? "heart.fill" : "heart")
                            .foregroundStyle(isTap ? .red : .primary)
                    }
                    
                    Button(action: {
                        viewModel.delete(note: note)
                        dismiss()
                    }) {
                        Image(systemName: "trash")
                    }
                }
                .font(.system(size: 20))
                .padding()
            }
            .background(Color.backgroundHomePage)
        }
        .navigationBarBackButtonHidden(true)
        .font(.system(size: 18))
        .foregroundStyle(.primary)
    }
}

#Preview {
    ContentView()
}
