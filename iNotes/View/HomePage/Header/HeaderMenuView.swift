import SwiftUI

struct HeaderMenuView: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 24))
            }
            .foregroundStyle(Color.blue.opacity(0.8))
        }
    }
}

#Preview {
    HeaderMenuView()
}
