import SwiftUI

struct HorizontalFilterView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(NoteCategory.allCases, id: \.self) { category in
                    VStack(spacing: 8) {
                        Button(action: {
                            notesViewModel.filterNotes(by: category)
                        }) {
                            Text(category.rawValue.capitalized)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(notesViewModel.selectedCategory == category ? .accentColor : .gray)
                                .padding(.horizontal)
                            
                        }
                        .buttonStyle(.plain)
                        
                        Rectangle()
                            .fill(notesViewModel.selectedCategory == category ? Color.accentColor : Color.clear)
                            .frame(width: 30, height: 2)
                            .animation(.easeInOut(duration: 0.2), value: notesViewModel.selectedCategory)
                    }
                }
            }
            .padding(.horizontal, 5)
            .padding(.top, 10)
            
            Divider()
        }
        
        .animation(.bouncy, value: notesViewModel.selectedCategory)
    }
}

#Preview {
    ContentView()
}
