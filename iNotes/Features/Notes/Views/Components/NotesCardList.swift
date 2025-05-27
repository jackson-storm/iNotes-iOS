import SwiftUI

struct NotesCardListView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    var body: some View {
        VStack(spacing: 0) {
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
        .animation(.bouncy, value: selectedNotes)
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
        VStack {
            HStack(alignment: .center, spacing: 20) {
                // Выбор при множественном выборе
                if isSelectionMode {
                    ZStack {
                        Circle()
                            .stroke(.secondary, lineWidth: 1)
                            .frame(width: 24, height: 24)

                        if selectedNotes.contains(note.id) {
                            Circle()
                                .fill(note.category.color)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .animation(.bouncy, value: selectedNotes)
                    .padding(.leading, 15)
                }

                // Содержимое карточки
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top) {
                        Text(note.title.isEmpty ? "Untitled" : note.title)
                            .font(.headline)
                            .lineLimit(1)
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

                            Image(systemName: note.category.icon)
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
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
                .padding(.vertical)
                .padding(.trailing, 15)
                .padding(.leading, isSelectionMode ? 0 : 15)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.backgroundComponents.opacity(0.1))
                .stroke(.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    ContentView()
}
