import SwiftUI

struct WelcomeFlowView: View {
    @StateObject private var viewModel = WelcomeFlowViewModel()
    
    var body: some View {
        VStack {
            TabView(selection: $viewModel.selectedPage) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    WelcomeFlowPageView(page: viewModel.pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            WelcomeFlowMenuView(
                selectedPage: $viewModel.selectedPage,
                totalPages: viewModel.pages.count,
                onComplete: viewModel.completeOnboarding,
                onNext: viewModel.nextPage
            )
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}

