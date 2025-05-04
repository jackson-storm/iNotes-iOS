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
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.backgroundComponents)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .frame(maxWidth: .infinity)
            
            VStack {
                HStack {
                    Text(note.title.isEmpty ? "No name" : note.title)
                        .lineLimit(2)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Text(note.description.isEmpty ? "Empty note" : note.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 5)
                        .lineLimit(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    HStack {
                        Text(note.lastEdited, formatter: dateFormatter)
                            .font(.footnote)
                        
                        Spacer()
                        
                        Text(note.lastEdited, formatter: timeFormatter)
                            .font(.footnote)
                            
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
