import SwiftUI

import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    var body: some View {
        VStack {
            if notesViewModel.filteredNotes.isEmpty {
                Spacer()
                EmptyStateView()
                Spacer()
            } else {
                ScrollView {
                    switch selectedDisplayTypeNotes {
                    case .list:
                        NotesCardListView(
                            notes: notesViewModel.filteredNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    case .grid:
                        NotesCardGridView(
                            notes: notesViewModel.filteredNotes,
                            notesViewModel: notesViewModel,
                            selectedNotes: $selectedNotes,
                            isSelectionMode: $isSelectionMode
                        )
                    }
                }
            }
        }
        .animation(.bouncy, value: selectedDisplayTypeNotes)
        .animation(.bouncy, value: notesViewModel.filteredNotes.count)
    }
}

private struct NotesCardListView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel

    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool

    var body: some View {
        VStack(spacing: 8) {
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

private struct NotesCardGridView: View {
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
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.headline)
                        .lineLimit(3)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
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

private struct NotesCardList: View {
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
                    .fill(note.category.color)
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

extension View {
    func noteContextMenu(
        note: Note,
        notesViewModel: NotesViewModel,
        isSelectionMode: Binding<Bool>
    ) -> some View {
        self.contextMenu {
            Button {
                isSelectionMode.wrappedValue = true
            } label: {
                Label("Select notes", systemImage: "checkmark.circle")
            }

            Button {
               
            } label: {
                Label("Add to archive", systemImage: "archivebox")
            }

            Button(role: .destructive) {
                notesViewModel.delete(note: note)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    ContentView()
}
