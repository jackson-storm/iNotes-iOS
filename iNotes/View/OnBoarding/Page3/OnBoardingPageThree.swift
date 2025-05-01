import SwiftUI

struct OnBoardingPageThree: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            OnBoardingDescriptions()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            OnboardingBackgroundView(image: "image3")
        )
        .ignoresSafeArea(.all)
    }
}

private struct OnBoardingDescriptions: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Plan and execute")
                .font(.system(size: 38, weight: .medium))
                .foregroundStyle(.white)
            
            Text("Set goals, monitor your progress, and achieve results with an intuitive planner")
                .font(.system(size: 18))
                .foregroundStyle(.white.opacity(0.7))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnBoardingPageThree()
}
