import SwiftUI

// TODO: переделать дизайн и проверить работу приложения
struct LoginView: View {
    @State private var usernameOrEmail: String = ""
    @State private var password: String = ""
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Username or Email", text: $usernameOrEmail)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            if let error = viewModel.loginError {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                viewModel.login(usernameOrEmail: usernameOrEmail, password: password)
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    LoginView()
}
