import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var loginError: String?
    @Published var registerError: String?
    @Published var isLoggedIn = false

    func login(usernameOrEmail: String, password: String) {
        let request = LoginRequest(login: usernameOrEmail, password: password)
        AuthService.shared.login(request: request) { result in
            switch result {
            case .success(let authResponse):
                self.isLoggedIn = true
            case .failure(let error):
                self.loginError = error.localizedDescription
            }
        }
    }

    func register(username: String, email: String, password: String) {
        let request = RegisterRequest(username: username, email: email, password: password)
        AuthService.shared.register(request: request) { result in
            switch result {
            case .success(let authResponse):
                self.isLoggedIn = true
            case .failure(let error):
                self.registerError = error.localizedDescription
            }
        }
    }
}
