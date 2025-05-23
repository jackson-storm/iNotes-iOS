import SwiftUI

struct ArchiveContentView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel
    
    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    
    var body: some View {
        let archivedNotes = notes.filter { $0.isArchive }
        
        if archivedNotes.isEmpty {
            EmptyStateArchiveView()
        } else {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(archivedNotes) { note in
                        Group {
                            if isSelectionMode {
                                ArchiveCardView(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
                            } else {
                                NavigationLink(destination: EditNotesView(note: note, notesViewModel: notesViewModel)) {
                                    ArchiveCardView(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
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
            }
            .animation(.bouncy, value: selectedDisplayTypeNotes)
            .animation(.bouncy, value: archivedNotes.count)
            .padding(.horizontal, 10)
        }
    }
}

private struct ArchiveCardView: View {
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
                    .stroke(note.category.color, lineWidth: selectedNotes.contains(note.id) ? 3 : 0)
            )
        }
    }
}

private struct EmptyStateArchiveView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "archivebox")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No notes available")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.bottom, 50)
    }
}

#Preview {
    ContentView()
}
