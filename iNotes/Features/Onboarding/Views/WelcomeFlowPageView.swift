import SwiftUI

struct WelcomeFlowPageView: View {
    let page: WelcomeFlowPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
        
            VStack(alignment: .leading, spacing: 20) {
                Text(page.title)
                    .font(.system(size: 38, weight: .medium))
                    .foregroundStyle(.white)
                
                Text(page.description)
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            WelcomeFlowBackgroundView(image: page.image)
        )
        .ignoresSafeArea()
    }
}

