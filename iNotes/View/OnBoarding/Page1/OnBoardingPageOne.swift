import SwiftUI

struct OnboardingPageOne: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            OnBoardingDescriptions()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            BackgroundPage(image: "image3")
        )
        .ignoresSafeArea(.all)
    }
}

private struct OnBoardingDescriptions: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Bring inspiration to life instantly")
                .font(.system(size: 38, weight: .medium))
                .foregroundStyle(.white)
            
            Text("Write down thoughts, notes, and ideas so you never forget anything. Your notes are always within reach")
                .font(.system(size: 18))
                .foregroundStyle(.white.opacity(0.7))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

private struct OnBoardingBackground: View {
    var body: some View {
        Rectangle()
            .fill(Color.black)
    }
}

#Preview {
    OnboardingPageOne()
}
