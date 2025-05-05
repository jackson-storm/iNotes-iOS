import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    @State private var isPasswordVisible: Bool = false
    
    var hasError: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundComponents)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(hasError ? Color.red : Color.gray.opacity(0.2), lineWidth: 1)
                )
                .frame(height: 50)
            
            HStack(spacing: 12) {
                Image(systemName: "envelope")
                    .font(.system(size: 20))
                    .foregroundStyle(.gray)
                
                TextField("Email", text: $email)
                    .foregroundColor(.primary)
                
                if !email.isEmpty {
                    Button(action: {
                        email = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .animation(.easeInOut, value: email)
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    EmailTextField(email: .constant(""))
}

