import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: NoteCategory = .all
    @StateObject private var notesViewModel = NotesViewModel()
    
    @AppStorage("selectedDisplayTypeNotes") private var selectedDisplayTypeNotes: DisplayTypeNotes = .list

    var body: some View {
        VStack(spacing: 15) {
            HeaderView(searchBarText: $notesViewModel.searchText)
            
            HorizontalFilterView(notesViewModel: notesViewModel)
            
            ZStack(alignment: .bottom) {
                NotesListView(
                    notesViewModel: notesViewModel,
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes
                )
                
                HomeCustomTabView(
                    selectedDisplayTypeNotes: $selectedDisplayTypeNotes,
                    notesViewModel: notesViewModel
                )
                .padding(.bottom, 30)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .padding(.top, 10)
        .background(Color.backgroundHomePage)
        .onAppear {
            notesViewModel.filterNotes(by: selectedCategory)
        }
        .onChange(of: selectedCategory) { newValue,_ in
            notesViewModel.filterNotes(by: newValue)
        }
    }
}

#Preview {
    ContentView()
}
