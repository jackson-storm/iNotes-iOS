import SwiftUI

struct CustomTabView: View {
    @ObservedObject var notesViewModel: NotesViewModel

    @Binding var selectedTab: Int
    @Binding var isSelectionMode: Bool
    @Binding var selectedNotes: Set<UUID>
    @Binding var deleteActionType: DeleteActionType?

    let note: Note

    var body: some View {
        HStack(spacing: isSelectionMode ? 20 : 35) {
            Spacer()

            if !isSelectionMode {
                TabButton(icon: selectedTab == 0 ? "archivebox.fill" : "archivebox", title: "Archive", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
            } else {
                Button(action: {
                    let currentFilteredNotes: [Note]

                    switch selectedTab {
                    case 0:
                        currentFilteredNotes = notesViewModel.notes.filter { $0.isArchive }
                    case 1:
                        currentFilteredNotes = notesViewModel.notes.filter { !$0.isArchive }
                    default:
                        currentFilteredNotes = []
                    }

                    if selectedNotes.count < currentFilteredNotes.count {
                        selectedNotes = Set(currentFilteredNotes.map { $0.id })
                    } else {
                        selectedNotes.removeAll()
                    }
                }) {
                    let currentFilteredNotesCount = selectedTab == 0 ?
                        notesViewModel.notes.filter { $0.isArchive }.count :
                        notesViewModel.notes.filter { !$0.isArchive }.count

                    Text(selectedNotes.count < currentFilteredNotesCount ? "Select All" : "Deselect All")
                }
            }

            Spacer()

            if !isSelectionMode {
                TabButton(icon: selectedTab == 1 ? "note.text" : "note", title: "Notes", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
            } else {
                Button {
                    for id in selectedNotes {
                        if let note = notesViewModel.notes.first(where: { $0.id == id }) {
                            notesViewModel.toggleArchive(for: note)
                        }
                    }
                    selectedNotes.removeAll()
                    isSelectionMode = false
                } label: {
                    var shouldUnarchiveSelectedNotes: Bool {
                        let selected = selectedNotes.compactMap { id in
                            notesViewModel.notes.first(where: { $0.id == id })
                        }
                        return !selected.isEmpty && selected.allSatisfy { $0.isArchive }
                    }
                    Text(shouldUnarchiveSelectedNotes ? "Unarchive" : "To Archive")
                }
                .disabled(selectedNotes.isEmpty)
            }

            Spacer()

            if !isSelectionMode {
                TabButton(icon: selectedTab == 2 ? "gearshape.fill" : "gearshape", title: "Settings", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            } else {
                Button("Delete") {
                    deleteActionType = .deleteSelected
                }
                .disabled(
                    selectedNotes.isEmpty ||
                    selectedNotes.contains { id in
                        notesViewModel.notes.first(where: { $0.id == id })?.isLock == true
                    }
                )
            }

            Spacer()
        }
        .animation(.bouncy, value: selectedNotes)
        .animation(.bouncy, value: isSelectionMode)
    }
}

private struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.caption)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}

private struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .accentColor : .gray)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .accentColor : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
