import SwiftUI

struct NotesCardGridView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(notes) { note in
                Group {
                    if isSelectionMode {
                        NotesCardGrid(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
                    } else {
                        NavigationLink(destination: EditNotesView(note: note, notesViewModel: notesViewModel)) {
                            NotesCardGrid(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onTapGesture {
                    if isSelectionMode {
                        if selectedNotes.contains(note.id) {
                            selectedNotes.remove(note.id)
                        } else {
                            selectedNotes.insert(note.id)
                        }
                    }
                }
                .foregroundStyle(.primary)
                .noteContextMenu(
                    note: note,
                    notesViewModel: notesViewModel,
                    isSelectionMode: $isSelectionMode
                )
            }
        }
        .animation(.bouncy, value: selectedNotes)
        .padding(.horizontal, 10)
        .padding(.top, 1)
    }
}

private struct NotesCardGrid: View {
    let note: Note
    
    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool
    
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
        HStack {
            if isSelectionMode {
                ZStack {
                    Circle()
                        .stroke(.secondary, lineWidth: 1)
                        .frame(width: 20, height: 20)
                    
                    if selectedNotes.contains(note.id) {
                        Circle()
                            .fill(note.category.color)
                            .frame(width: 18, height: 18)
                    }
                }
                .padding(.horizontal, 5)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.headline)
                        .lineLimit(3)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        if note.isArchive {
                            Image(systemName: "archivebox.fill")
                                .foregroundStyle(.blue)
                        }
                        
                        if note.isLiked {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(note.category.color)
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: note.category.icon)
                                .foregroundStyle(.white)
                                .font(.system(size: 13))
                        }
                    }
                }
                
                if !note.secretNotesEnabled {
                    Text(note.description.isEmpty ? "No description" : note.description)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                } else {
                    HStack {
                        Text("Blocked")
                        Image(systemName: "lock.fill")
                        Spacer()
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                }
                
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
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundComponents)
                    .stroke(.gray.opacity(0.1), lineWidth: 1)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(note.category.color, lineWidth: selectedNotes.contains(note.id) ? 3 : 0)
            )
        }
    }
}
