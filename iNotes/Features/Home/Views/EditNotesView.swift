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
                Button(action: {
                    dismiss()
                }) {
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
                    Button(action: {}) {
                        Image(systemName: "heart")
                    }
                    Button(action: {}) {
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
