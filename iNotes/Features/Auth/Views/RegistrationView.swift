import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            Text("Registration")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 15) {
                UsernameTextField(username: $username, hasError: viewModel.usernameError != nil)
                
                if let usernameError = viewModel.usernameError {
                    Text(usernameError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.leading, 5)
                }
                
                EmailTextField(email: $email, hasError: viewModel.emailError != nil)
                
                if let emailError = viewModel.emailError {
                    Text(emailError)
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
                
                if let generalError = viewModel.registerError {
                    Text(generalError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
            
            Button(action: {
                if viewModel.validateRegister(username: username, email: email, password: password) {
                    viewModel.register(username: username, email: email, password: password)
                }
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color.backgroundHomePage)
    }
}

#Preview {
    RegistrationView()
}
