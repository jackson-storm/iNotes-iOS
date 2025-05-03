import SwiftUI

struct CustomBackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(Color.backgroundHomePage)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
