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
                            .foregroundColor(.primary)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(notesViewModel.selectedCategory == category ? Color.accentColor.opacity(0.15) : Color.backgroundButton)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(notesViewModel.selectedCategory == category ? Color.accentColor : Color.clear)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            
            Divider()
        }
        .animation(.easeInOut(duration: 0.3), value: notesViewModel.selectedCategory)
    }
}

#Preview {
    ContentView()
}
