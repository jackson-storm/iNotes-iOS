import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    
    @State private var selectedNote: Note?
    @State private var isEditing = false
    
    @State private var selectedNotes: Set<UUID> = []
    @State private var isSelectionMode = false
    
    var body: some View {
        NavigationStack {
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
                                selectedNote: $selectedNote,
                                isEditing: $isEditing,
                                selectedNotes: $selectedNotes,
                                isSelectionMode: $isSelectionMode
                            )
                        case .grid:
                            NotesCardGridView(
                                notes: notesViewModel.filteredNotes,
                                notesViewModel: notesViewModel,
                                selectedNote: $selectedNote,
                                isEditing: $isEditing,
                                selectedNotes: $selectedNotes,
                                isSelectionMode: $isSelectionMode
                            )
                        case .timeLine:
                            NotesCardTimelineView(
                                notes: notesViewModel.filteredNotes,
                                notesViewModel: notesViewModel,
                                selectedNote: $selectedNote,
                                isEditing: $isEditing,
                                selectedNotes: $selectedNotes,
                                isSelectionMode: $isSelectionMode
                            )
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isEditing) {
                if let selectedNote = selectedNote {
                    EditNotesView(note: selectedNote, viewModel: notesViewModel)
                }
            }
            .toolbar {
                if isSelectionMode {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            selectedNotes.removeAll()
                            isSelectionMode = false
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Delete (\(selectedNotes.count))") {
                            notesViewModel.delete(notesWithIDs: selectedNotes)
                            selectedNotes.removeAll()
                            isSelectionMode = false
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .animation(.easeInOut, value: isSelectionMode)
    }
}

private struct NotesCardListView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel
    
    @Binding var selectedNote: Note?
    @Binding var isEditing: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(notes) { note in
                NotesCardList(note: note, selectedNotes: $selectedNotes)
                    .onTapGesture {
                        if isSelectionMode {
                            if selectedNotes.contains(note.id) {
                                selectedNotes.remove(note.id)
                            } else {
                                selectedNotes.insert(note.id)
                            }
                        } else {
                            selectedNote = note
                            isEditing = true
                        }
                    }
                    .foregroundStyle(.primary)
                    .contextMenu {
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Edit note", systemImage: "note")
                        }
                        
                        Button {
                            isSelectionMode = true
                        } label: {
                            Label("Select", systemImage: "checkmark.circle")
                        }
                        
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Change category", systemImage: "tag")
                        }
                        
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Add to archive", systemImage: "archivebox")
                        }
        
                        Button(role: .destructive) {
                            notesViewModel.delete(note: note)
                            if selectedNote?.id == note.id {
                                selectedNote = nil
                                isEditing = false
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 1)
    }
}

private struct NotesCardTimelineView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel
    
    @Binding var selectedNote: Note?
    @Binding var isEditing: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool
    
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(notes) { note in
                NotesCardTimeline(note: note, selectedNotes: $selectedNotes)
                    .onTapGesture {
                        if isSelectionMode {
                            if selectedNotes.contains(note.id) {
                                selectedNotes.remove(note.id)
                            } else {
                                selectedNotes.insert(note.id)
                            }
                        } else {
                            selectedNote = note
                            isEditing = true
                        }
                    }
                    .foregroundStyle(.primary)
                    .contextMenu {
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Edit note", systemImage: "note")
                        }
                        
                        Button {
                            isSelectionMode = true
                        } label: {
                            Label("Select", systemImage: "checkmark.circle")
                        }
                        
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Change category", systemImage: "tag")
                        }
                        
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Add to archive", systemImage: "archivebox")
                        }
                        
                        Button(role: .destructive) {
                            notesViewModel.delete(note: note)
                            if selectedNote?.id == note.id {
                                selectedNote = nil
                                isEditing = false
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 1)
    }
}

private struct NotesCardGridView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel
    
    @Binding var selectedNote: Note?
    @Binding var isEditing: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(notes) { note in
                NotesCardGrid(note: note, selectedNotes: $selectedNotes)
                    .onTapGesture {
                        if isSelectionMode {
                            if selectedNotes.contains(note.id) {
                                selectedNotes.remove(note.id)
                            } else {
                                selectedNotes.insert(note.id)
                            }
                        } else {
                            selectedNote = note
                            isEditing = true
                        }
                    }
                    .foregroundStyle(.primary)
                    .contextMenu {
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Edit note", systemImage: "note")
                        }
                        
                        Button {
                            isSelectionMode = true
                        } label: {
                            Label("Select", systemImage: "checkmark.circle")
                        }
                        
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Change category", systemImage: "tag")
                        }
                        
                        Button {
                            selectedNote = note
                            isEditing = true
                        } label: {
                            Label("Add to archive", systemImage: "archivebox")
                        }
                        
                        Button(role: .destructive) {
                            notesViewModel.delete(note: note)
                            if selectedNote?.id == note.id {
                                selectedNote = nil
                                isEditing = false
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 1)
    }
}

private struct NotesCardGrid: View {
    let note: Note
    @Binding var selectedNotes: Set<UUID>
    
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

private struct NotesCardList: View {
    let note: Note
    @Binding var selectedNotes: Set<UUID>
    
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
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(note.category.color)
                .frame(width: 8)
            
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

private struct NotesCardTimeline: View {
    let note: Note
    @Binding var selectedNotes: Set<UUID>
    
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
        HStack(alignment: .top, spacing: 12) {
            VStack {
                Circle()
                    .fill(note.category.color)
                    .frame(width: 12, height: 12)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if note.isLiked {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
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
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 3)
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

#Preview {
    ContentView()
}
