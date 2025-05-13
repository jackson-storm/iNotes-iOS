import SwiftUI

struct ContentView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    @StateObject private var authViewModel = AuthViewModel()
    @State private var selectedNotes: Set<UUID> = []
    @State private var isSelectionMode = false
    
    var body: some View {
        if hasLaunchedBefore {
            NavigationStack {
                if !authViewModel.isLoggedIn {
                    HomeView(isSelectionMode: $isSelectionMode, selectedNotes: $selectedNotes)
                } else {
                    if authViewModel.isLoggedIn {
                        HomeView(isSelectionMode: $isSelectionMode, selectedNotes: $selectedNotes)
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
    ContentView()
}
