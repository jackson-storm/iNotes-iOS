import SwiftUI

struct ContentView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false

    var body: some View {
        if hasLaunchedBefore {
            HomePageView()
        } else {
            OnBoardingMainView()
        }
    }
}

#Preview {
    ContentView()
}
