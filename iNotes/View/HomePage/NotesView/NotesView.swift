import SwiftUI

struct NotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
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
                    NotesCardView(notesViewModel: notesViewModel)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    HomePageView()
}
