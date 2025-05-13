import SwiftUI

struct HorizontalFilterView: View {
    @ObservedObject var notesViewModel: NotesViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(NoteCategory.allCases, id: \.self) { category in
                    Button(action: {
                        notesViewModel.filterNotes(by: category)
                    }) {
                        Text(category.rawValue.capitalized)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(notesViewModel.selectedCategory == category ? .white : .primary)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(notesViewModel.selectedCategory == category ? Color.blue : Color.backgroundComponents)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.gray.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .animation(.easeInOut(duration: 0.3), value: notesViewModel.selectedCategory)
    }
}
