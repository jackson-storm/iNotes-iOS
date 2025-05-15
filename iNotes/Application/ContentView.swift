import SwiftUI

struct ContentView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    @StateObject private var authViewModel = AuthViewModel()
    @State private var selectedNotes: Set<UUID> = []
    @State private var isSelectionMode = false
    @State private var sortType: NotesSortType = .creationDate
    
    var body: some View {
        if hasLaunchedBefore {
            NavigationStack {
                if !authViewModel.isLoggedIn {
                    HomeView(
                        isSelectionMode: $isSelectionMode,
                        selectedNotes: $selectedNotes,
                        sortType: $sortType
                    )
                } else {
                    if authViewModel.isLoggedIn {
                        HomeView(
                            isSelectionMode: $isSelectionMode,
                            selectedNotes: $selectedNotes,
                            sortType: $sortType
                        )
                    } else {
                        RegistrationView().environmentObject(authViewModel)
                    }
                }
            }
        } else {
            WelcomeFlowView()
        }
    }
}

#Preview {
    WelcomeFlowView()
}
