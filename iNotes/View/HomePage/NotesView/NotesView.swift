import SwiftUI

struct NotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if notesViewModel.notes.isEmpty {
                Spacer()
                
                VStack(spacing: 10) {
                    Image(systemName: "menucard")
                    Text("Empty notes")
                        
                }
                .foregroundColor(.gray)
                .font(.system(size: 24))
                
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(notesViewModel.notes, id: \.self) { note in
                            Text(note)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.backgroundNotes)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    HomePageView()
}
