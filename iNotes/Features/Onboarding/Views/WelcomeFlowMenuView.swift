import SwiftUI

struct WelcomeFlowMenuView: View {
    @Binding var selectedPage: Int
    let totalPages: Int
    let onComplete: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(selectedPage == index ? Color.white : Color.secondary)
                        .frame(width: 10, height: 10)
                        .scaleEffect(selectedPage == index ? 1.1 : 1.0)
                        .animation(.easeInOut, value: selectedPage)
                }
            }
            
            Spacer()
            
            if selectedPage == totalPages - 1 {
                Button(action: onComplete) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.clear)
                            .stroke(.gray, lineWidth: 1)
                        
                        Text("Get Started")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                .frame(width: 180, height: 40)
            } else {
                Button(action: onNext) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.clear)
                            .stroke(.gray, lineWidth: 1)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .frame(width: 70, height: 40)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 50)
    }
}
