import SwiftUI

struct InformationUnlockText: View {
    @Binding var isActiveEnterPassword: Bool
    
    var body: some View {
        ZStack {
            Color.backgroundHomePage
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.secondary)
                    .opacity(0.8)
                
                Text("This note is password protected. \nEnter your password.")
                    .font(.callout)
                    .foregroundStyle(.primary.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Button {
                    withAnimation {
                        isActiveEnterPassword = true
                    }
                } label: {
                    Text("Unlock")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 50)
        }
        .transition(.opacity)
    }
}
