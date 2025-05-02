import SwiftUI

struct OnBoardingView: View {
    @State private var selectedPage: Int = 0
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    var body: some View {
        VStack {
            TabView(selection: $selectedPage){
                OnboardingPageOne()
                    .tag(0)
                OnBoardingPageTwo()
                    .tag(1)
                OnBoardingPageThree()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            OnBoardingMenuView(selectedPage: $selectedPage)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
