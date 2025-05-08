import SwiftUI

class WelcomeFlowViewModel: ObservableObject {
    @Published var selectedPage: Int = 0
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    
    let pages: [WelcomeFlowPage] = [
        WelcomeFlowPage(
            title: "Bring inspiration to life instantly",
            description: "Write down thoughts, notes, and ideas so you never forget anything. Your notes are always within reach.",
            image: "image3"
        ),
        WelcomeFlowPage(
            title: "Make your tasks simpler",
            description: "Create to-do lists, set priorities, and track your progress with easy-to-use management tools.",
            image: "image4"
        ),
        WelcomeFlowPage(
            title: "Plan and execute",
            description: "Set goals, monitor your progress, and achieve results with an intuitive planner.",
            image: "image5"
        )
    ]
    
    func nextPage() {
        if selectedPage < pages.count - 1 {
            selectedPage += 1
        }
    }
    
    func completeOnboarding() {
        hasLaunchedBefore = true
    }
}
