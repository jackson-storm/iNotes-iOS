import SwiftUI

struct NotesCardListView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    var body: some View {
        VStack(spacing: 5) {
            ForEach(notes) { note in
                Group {
                    if isSelectionMode {
                        NotesCardList(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
                    } else {
                        NavigationLink(destination: EditNotesView(note: note, notesViewModel: notesViewModel)) {
                            NotesCardList(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
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
        .padding(.horizontal, 10)
        .padding(.top, 1)
    }
}

struct NotesCardList: View {
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
        HStack(alignment: .center, spacing: 10) {
            if isSelectionMode {
                ZStack {
                    Circle()
                        .stroke(.primary, lineWidth: 1)
                        .frame(width: 20, height: 20)
                    
                    if selectedNotes.contains(note.id) {
                        Circle()
                            .fill(note.category.color)
                            .frame(width: 16, height: 16)
                    }
                }
                .animation(.bouncy, value: selectedNotes)
                .padding(.horizontal, 5)
                
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(note.category.color.opacity(0.55))
                    .stroke(note.category.color, lineWidth: 1)
                    .frame(width: 8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        if note.isArchive {
                            Image(systemName: "archivebox.fill")
                                .foregroundStyle(.blue)
                        }
                        
                        if note.isLiked {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                        }
                        
                        Image(systemName: note.category.icon)
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .background(
                                Circle()
                                    .fill(note.category.color)
                                    .frame(width: 30, height: 30)
                            )
                    }
                }
                
                if !note.secretNotesEnabled {
                    Text(note.description.isEmpty ? "No description" : note.description)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .foregroundColor(.secondary)
                } else {
                    HStack {
                        Text("Blocked")
                        Image(systemName: "lock.fill")
                        Spacer()
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
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
                    .stroke(note.category.color, lineWidth: selectedNotes.contains(note.id) ? 2 : 0)
            )
        }
    }
}
