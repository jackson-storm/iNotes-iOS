import SwiftUI

struct CustomTabView: View {
    @State private var isSheetPresented = false
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(.ultraThinMaterial)
                .frame(width: 200, height: 65)
            
            HStack(spacing: 23) {
                
                Button(action: {
                    // Другие действия
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20))
                }
                
                Button(action: {
                    isSheetPresented = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.backgroundSelected)
                            .frame(width: 55, height: 55)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                }
                
                Button(action: {
                    notesViewModel.deleteAllNotes()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                }
            }
            .foregroundStyle(.primary)
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                AddNoteView(isPresented: $isSheetPresented, viewModel: notesViewModel)
            }
            .presentationBackground(Color.backgroundHomePage)
        }
    }
}
