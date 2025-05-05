import SwiftUI

// TODO: переделать дизайн и проверить работу приложения
struct RegistrationView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            if let error = viewModel.registerError {
                Text(error)
                    .foregroundColor(.red)
            }

            Button(action: {
                viewModel.register(username: username, email: email, password: password)
            }) {
                Text("Register")
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
    RegistrationView()
}
