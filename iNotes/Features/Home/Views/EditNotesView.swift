import SwiftUI

struct EditNotesView: View {
    let note: Note
    @Environment(\.dismiss) var dismiss
    
    @State private var description: String
    @State private var title: String

    init(note: Note) {
        self.note = note
        _description = State(initialValue: note.description)
        _title = State(initialValue: note.title)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.primary)
                        .padding()
                        
                }
                
                TextField("", text: $title)
                    .bold()
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "archivebox")
                    }
                    Button(action: {}) {
                        Image(systemName: "heart")
                    }
                    Button(action: {}) {
                        Image(systemName: "trash")
                    }
                }
                .padding()
            }
            .background(Color.backgroundComponents)
            
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.backgroundHomePage)
                    .frame(width: .infinity, height: .infinity)
                    .ignoresSafeArea(.all)
                    
                
                ZStack(alignment: .topLeading) {
                    if description.isEmpty {
                        Text("Enter description")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 13)
                    }
                    TextEditor(text: $description)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .opacity(description.isEmpty ? 0.7 : 1)
                }
            }
                
        }
        .navigationBarBackButtonHidden(true)
        .font(.system(size: 18))
        .foregroundStyle(.primary)
    }
}


#Preview {
    ContentView()
}
