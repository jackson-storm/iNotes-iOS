import SwiftUI

struct UsernameTextField: View {
    @Binding var username: String
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
                Image(systemName: "person")
                    .font(.system(size: 20))
                    .foregroundStyle(.gray)
                
                TextField("Username", text: $username)
                    .foregroundColor(.primary)
                
                if !username.isEmpty {
                    Button(action: {
                        username = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .animation(.easeInOut, value: username)
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    UsernameTextField(username: .constant(""))
}

