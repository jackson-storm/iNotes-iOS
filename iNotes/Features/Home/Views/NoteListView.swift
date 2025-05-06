import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        VStack {
            if notesViewModel.filteredNotes.isEmpty {
                Spacer()
                EmptyStateView()
                Spacer()
            } else {
                ScrollView {
                    NotesCardGridView(notes: notesViewModel.filteredNotes)
                }
            }
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "menucard")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No notes available")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
        }
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
                NavigationLink(destination: EditNotesView(note: note)) {
                    NotesCard(note: note)
                }
                .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

private struct NotesCard: View {
    let note: Note
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(note.category.color)
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: note.category.icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 13))
                }
            }
            
            Text(note.description.isEmpty ? "No description" : note.description)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .foregroundColor(.secondary)
                .padding(.top, 15)
            
            Spacer()
            
            HStack {
                Text(note.lastEdited, formatter: dateFormatter)
                    .font(.footnote)
             
                Spacer()
                Text(note.lastEdited, formatter: timeFormatter)
                    .font(.footnote)
                  
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.backgroundComponents)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
    }
}

#Preview {
    ContentView()
}
