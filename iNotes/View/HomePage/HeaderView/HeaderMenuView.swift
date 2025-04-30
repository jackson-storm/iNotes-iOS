import SwiftUI

struct HeaderMenuView: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 24))
            }
            .foregroundStyle(.secondary)
        }
    }
}
