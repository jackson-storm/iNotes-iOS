import SwiftUI

struct HomeCustomTabView: View {
    @State private var isSheetPresented = false
    @State private var noteTitle = ""
    @State private var description = ""
    @State private var noteExists = false
    @State private var showNoteExists = false
    @State private var showActionSheet: Bool = false
    @State private var showDeleteActionSheet: Bool = false
    
    @Binding var selectedDisplayTypeNotes: DisplayTypeNotes
    
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(.ultraThinMaterial)
                .stroke(.gray.opacity(0.1), lineWidth: 1)
                .frame(width: 65, height: 65)
            
            HStack(spacing: 20) {
                Button(action: {
                    isSheetPresented = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 55, height: 55)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                }
            }
            .foregroundStyle(.primary)
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                CategoriesNotesView(
                    isPresented: $isSheetPresented,
                    noteTitle: $noteTitle, description: $description,
                    noteExists: $noteExists,
                    showNoteExists: $showNoteExists,
                    viewModel: notesViewModel
                )
            }
            .presentationBackground(Color.backgroundHomePage)
        }
    }
}

#Preview {
    ContentView()
}
