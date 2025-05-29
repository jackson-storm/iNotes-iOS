import SwiftUI

struct SecretNotesToggle: View {
    @Binding var isSecret: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.backgroundComponents)
                .stroke(.gray.opacity(0.1), lineWidth: 1)
                .frame(height: 50)

            Toggle("Secret Notes", isOn: $isSecret)
                .padding(.horizontal, 15)
        }
        .padding(.horizontal, 20)
    }
}


