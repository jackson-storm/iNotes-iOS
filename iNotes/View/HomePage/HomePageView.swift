import SwiftUI

struct HomePageView: View {
    @State private var searchText: String = ""
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            SearchBarView(searchBarText: $searchText)
            
            HorizontalCalendarView()
            
            HorizontalFilterView()
            
            ZStack(alignment: .bottom) {
                NotesView(notesViewModel: notesViewModel)
                
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
    HomePageView()
}
