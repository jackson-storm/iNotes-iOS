import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(searchBarText: $searchText)
            
            HorizontalCalendarView()
            
            HorizontalFilterView()
            
            ZStack(alignment: .bottom) {
                NotesListView(notesViewModel: notesViewModel)
                
                CustomTabView(notesViewModel: notesViewModel)
                    .padding(.bottom, 30)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .padding(.top, 10)
        .background(Color.backgroundHomePage)
    }
}

#Preview {
    HomeView()
}
