import SwiftUI

struct PasswordTextField: View {
    @Binding var password: String
    var hasError: Bool = false
    @State private var isPasswordVisible: Bool = false

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
                Image(systemName: "lock")
                    .font(.system(size: 20))
                    .foregroundStyle(.gray)
                
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .foregroundColor(.primary)
                } else {
                    SecureField("Password", text: $password)
                        .foregroundColor(.primary)
                        .textContentType(.password)
                }
                
                if !password.isEmpty {
                    Button(action: {
                        password = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
                
                if !password.isEmpty {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .animation(.easeInOut, value: password)
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    PasswordTextField(password: .constant(""), hasError: false)
}
