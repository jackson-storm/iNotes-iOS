import Foundation

struct PasswordValidator {
    static func validate(password: String, confirmPassword: String) -> String? {
        if password.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Password cannot be empty"
        }
        if confirmPassword.isEmpty {
            return "Please repeat the password"
        }
        if password != confirmPassword {
            return "Passwords do not match"
        }
        if password.count < 6 {
            return "Password must be at least 6 characters"
        }
        if password.count > 64 {
            return "Password is too long"
        }
        if password.contains(" ") {
            return "Password cannot contain spaces"
        }
        if isTooSimple(password) {
            return "Password is too simple"
        }
        return nil
    }

    private static func isTooSimple(_ password: String) -> Bool {
        let onlyLetters = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: password))
        let onlyNumbers = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: password))
        return onlyLetters || onlyNumbers
    }
}
