import SwiftUI

struct ProfileImage: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
            }
            .foregroundStyle(Color.blue.opacity(0.8))
        }
    }
}
