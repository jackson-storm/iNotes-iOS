import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var loginError: String?
    @Published var registerError: String?

    @Published var usernameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?

    @Published var isLoggedIn = false

    init() {
        if UserDefaults.standard.string(forKey: "token") != nil {
            isLoggedIn = true
        }
    }

    func login(usernameOrEmail: String, password: String) {
        clearErrors()
        let request = LoginRequest(login: usernameOrEmail, password: password)
        AuthService.shared.login(request: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.token, forKey: "token")
                    self.isLoggedIn = true
                case .failure(let error):
                    self.loginError = error.localizedDescription
                }
            }
        }
    }

    func register(username: String, email: String, password: String) {
        clearErrors()
        let request = RegisterRequest(username: username, email: email, password: password)
        AuthService.shared.register(request: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.token, forKey: "token")
                    self.isLoggedIn = true
                case .failure(let error):
                    self.registerError = error.localizedDescription
                }
            }
        }
    }

    func validateRegister(username: String, email: String, password: String) -> Bool {
        clearErrors()
        var hasError = false

        if !isValidUsername(username) {
            usernameError = "Имя пользователя должно содержать минимум 3 символа"
            hasError = true
        }

        if !isValidEmail(email) {
            emailError = "Введите корректный email"
            hasError = true
        }

        if !isValidPassword(password) {
            passwordError = "Пароль должен содержать минимум 8 символов"
            hasError = true
        }

        return !hasError
    }

    func validateLogin(usernameOrEmail: String, password: String) -> Bool {
        clearErrors()
        var hasError = false

        if !isValidEmailOrUsername(usernameOrEmail) {
            usernameError = "Введите корректный логин или email"
            hasError = true
        }

        if !isValidPassword(password) {
            passwordError = "Пароль должен содержать минимум 8 символов"
            hasError = true
        }

        return !hasError
    }

    private func clearErrors() {
        usernameError = nil
        emailError = nil
        passwordError = nil
        loginError = nil
        registerError = nil
    }

    private func isValidEmailOrUsername(_ input: String) -> Bool {
        isValidEmail(input) || isValidUsername(input)
    }

    private func isValidUsername(_ username: String) -> Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty && username.count >= 3
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        password.count >= 8
    }
}
