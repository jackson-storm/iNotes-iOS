import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: NoteCategory = .all
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            HeaderView(searchBarText: $searchText)
            
            HorizontalCalendarView()
            
            HorizontalFilterView(selectedCategory: $selectedCategory, notesViewModel: notesViewModel)
            
            ZStack(alignment: .bottom) {
                NotesListView(notesViewModel: notesViewModel)
                
                CustomTabView(notesViewModel: notesViewModel)
                    .padding(.bottom, 30)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .padding(.top, 10)
        .background(Color.backgroundHomePage)
        .onAppear {
            notesViewModel.filterNotes(by: selectedCategory)
        }
    }
}

#Preview {
    HomeView()
}
