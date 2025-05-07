import SwiftUI

struct ContentView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        if hasLaunchedBefore {
            NavigationStack {
//                HomeView()
                if authViewModel.isLoggedIn {
                    HomeView()
                } else {
                    RegistrationView().environmentObject(authViewModel)
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
