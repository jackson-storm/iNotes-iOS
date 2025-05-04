import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        VStack {
            if notesViewModel.notes.isEmpty {
                Spacer()
                EmptyStateView()
                Spacer()
            } else {
                ScrollView {
                    NotesCardGridView(notes: notesViewModel.notes)
                }
            }
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "menucard")
                .font(.system(size: 24))
            Text("Empty notes")
                .font(.system(size: 24))
        }
        .foregroundColor(.gray)
        .padding(.bottom, 50)
    }
}

private struct NotesCardGridView: View {
    let notes: [Note]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(notes) { note in
                NotesCard(note: note)
            }
        }
        .padding()
    }
}

private struct NotesCard: View {
    let note: Note
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.backgroundComponents)
                .frame(minHeight: 180)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            VStack {
                Text(note.title)
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 5)
                    .padding(.top)
                
                Spacer()
                
                Text(note.content.isEmpty ? "Empty note" : note.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                
                Spacer()
                
                Text("Edited: \(note.lastEdited.formatted())")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    ContentView()
}
