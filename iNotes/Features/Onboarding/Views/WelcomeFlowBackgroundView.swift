import SwiftUI

struct WelcomeFlowBackgroundView: View {
    var image: String
    
    var body: some View {
        ZStack {
            Image(image)
                
            
            LinearGradient(
                gradient: Gradient(colors: [
                    .black,
                    .black.opacity(0.9),
                    .black.opacity(0.7),
                    .black.opacity(0.4),
                    .clear]),
                
                startPoint: .bottom,
                endPoint: .center
            )
        }
        .ignoresSafeArea()
    }
}

