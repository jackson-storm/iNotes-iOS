import SwiftUI

struct ArchiveCardView: View {
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
            HStack {
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
                    .padding(.horizontal, 15)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(note.title.isEmpty ? "Untitled" : note.title)
                            .font(.headline)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            if note.isLiked {
                                ZStack {
                                    Circle()
                                        .fill(.red.opacity(0.1))
                                        .stroke(.secondary, lineWidth: 1)
                                        .frame(width: 30, height: 30)
                                    
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 15))
                                }
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
                        .padding(.trailing, 5)
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
                .padding(isSelectionMode ? .trailing : .horizontal)
                .padding(.vertical)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.backgroundComponents.opacity(0.1))
                .stroke(.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

struct EmptyStateArchiveView: View {
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
