import SwiftUI

struct LoginView: View {
    @State private var usernameOrEmail: String = ""
    @State private var password: String = ""
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 15) {
                UsernameTextField(username: $usernameOrEmail, hasError: viewModel.usernameError != nil)
                
                if let usernameError = viewModel.usernameError {
                    Text(usernameError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.leading, 5)
                }
                
                PasswordTextField(password: $password, hasError: viewModel.passwordError != nil)
                
                if let passwordError = viewModel.passwordError {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.leading, 5)
                }
                
                if let generalError = viewModel.loginError {
                    Text(generalError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
            
            Button(action: {
                if viewModel.validateLogin(usernameOrEmail: usernameOrEmail, password: password) {
                    viewModel.login(usernameOrEmail: usernameOrEmail, password: password)
                }
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            HStack {
                Spacer()
                
                Text("Don't have an account?")
                NavigationLink(destination: RegistrationView()) {
                    Text("Register")
                        .foregroundColor(.blue)
                        .underline()
                }
                Spacer()
            }
            .font(.subheadline)
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color.backgroundHomePage)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        LoginView()
    }
}
