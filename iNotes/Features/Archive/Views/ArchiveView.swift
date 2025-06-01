import SwiftUI

struct ArchiveContentView: View {
    let notes: [Note]
    let notesViewModel: NotesViewModel
    let createPasswordViewModel: CreatePasswordViewModel
    
    @Binding var selectedNotes: Set<UUID>
    @Binding var isSelectionMode: Bool
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    @Binding var deleteActionType: DeleteActionType?
    
    @Binding var searchText: String
    @Binding var selectedTab: Int
    
    @State private var activeSearchBar = false
    
    var body: some View {
        NavigationStack {
            let archivedNotes = notes.filter { $0.isArchive }
            if archivedNotes.isEmpty {
                EmptyStateArchiveView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(archivedNotes) { note in
                            Group {
                                if isSelectionMode {
                                    NotesCardList(
                                        note: note,
                                        selectedNotes: $selectedNotes,
                                        isSelectionMode: $isSelectionMode
                                    )
                                } else {
                                    NavigationLink(destination: EditNotesView(
                                        note: note,
                                        notesViewModel: notesViewModel,
                                        createPasswordViewModel: createPasswordViewModel
                                    )) {
                                        NotesCardList(
                                            note: note,
                                            selectedNotes: $selectedNotes,
                                            isSelectionMode: $isSelectionMode
                                        )
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
                .animation(.bouncy, value: archivedNotes.count)
            }
        }
        .animation(.bouncy, value: activeSearchBar)
        .animation(.interpolatingSpring, value: isSelectionMode)
        .navigationTitle("Archive")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.backgroundComponents.opacity(0.6), for: .navigationBar)
        .toolbar {
            if !activeSearchBar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if isSelectionMode {
                        Button("Cancel") {
                            selectedNotes.removeAll()
                            isSelectionMode = false
                        }
                    } else {
                        Button("Edit") {
                            isSelectionMode = true
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        if isSelectionMode {
                            Text("Selected: \(selectedNotes.count)")
                                .bold()
                        } else {
                            Image(systemName: "archivebox.fill")
                                .font(.system(size: 13))
                            Text("Archive")
                                .bold()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        activeSearchBar = true
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        activeSearchBar = false
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.backgroundComponents)
                            .frame(height: 35)
                        
                        if searchText.isEmpty {
                            Text("Search")
                                .foregroundColor(.gray)
                                .padding(.leading, 50)
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                            
                            TextField("", text: $searchText)
                                .foregroundColor(.primary)
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.medium)
                                }
                                .foregroundStyle(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 100)
                }
            }
        }
        .actionSheet(item: $deleteActionType) { actionType in
            switch actionType {
            case .deleteAll:
                return ActionSheet(
                    title: Text("Delete notes?"),
                    message: Text("This action is irreversible."),
                    buttons: [
                        .destructive(Text("Delete all notes")) {
                            notesViewModel.deleteAllNotes()
                            isSelectionMode = false
                        },
                        .cancel()
                    ]
                )
            case .deleteSelected:
                return ActionSheet(
                    title: Text("Delete selected notes?"),
                    message: Text("This action is irreversible."),
                    buttons: [
                        .destructive(Text("Delete \(selectedNotes.count) notes")) {
                            notesViewModel.delete(notesWithIDs: selectedNotes)
                            selectedNotes.removeAll()
                            isSelectionMode = false
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
}

private struct EmptyStateArchiveView: View {
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
