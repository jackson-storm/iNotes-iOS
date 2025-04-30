import SwiftUI

struct OnBoardingPageTwo: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            OnBoardingDescriptions()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            BackgroundPage(image: "image4")
        )
        .ignoresSafeArea(.all)
    }
}

private struct OnBoardingDescriptions: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Make your tasks simpler")
                .font(.system(size: 38, weight: .medium))
                .foregroundStyle(.white)
            
            Text("Create to-do lists, set priorities, and track your progress with easy-to-use management tools")
                .font(.system(size: 18))
                .foregroundStyle(.white.opacity(0.7))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnBoardingPageTwo()
}
