import SwiftUI

struct NotesCardGridView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel
    let createPasswordViewModel: CreatePasswordViewModel

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(notes) { note in
                Group {
                    if isSelectionMode {
                        NotesCardGrid(note: note, selectedNotes: $selectedNotes, isSelectionMode: $isSelectionMode)
                    } else {
                        NavigationLink(destination: EditNotesView(
                            note: note,
                            notesViewModel: notesViewModel,
                            createPasswordViewModel: createPasswordViewModel
                        )) {
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
        .padding(.top, 10)
        .animation(.bouncy, value: selectedNotes)
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
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.headline)
                        .lineLimit(3)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        if note.isArchive {
                            Image(systemName: "archivebox.fill")
                                .foregroundStyle(.blue)
                        }
                        
                        if note.isLiked {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                        }
                        
                        VStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(note.category.color)
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: note.category.icon)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13))
                            }
                            if note.isLock {
                                ZStack {
                                    Circle()
                                        .fill(.blue.opacity(0.1))
                                        .stroke(.secondary, lineWidth: 1)
                                        .frame(width: 30, height: 30)

                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 15))
                                }
                                .foregroundStyle(.blue)
                            }
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
                RoundedRectangle(cornerRadius: 0)
                    .fill(isSelectionMode ?  Color.backgroundComponents.opacity(0.5) : Color.backgroundHomePage)
                    .stroke(.gray.opacity(0.1), lineWidth: 1)
                   
            )
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .fill(selectedNotes.contains(note.id) ? Color.accentColor.opacity(0.05) : Color.clear)
                    .stroke(Color.accentColor, lineWidth: selectedNotes.contains(note.id) ? 1 : 0)
            )
            
            if isSelectionMode {
                ZStack {
                    if selectedNotes.contains(note.id) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 14))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
