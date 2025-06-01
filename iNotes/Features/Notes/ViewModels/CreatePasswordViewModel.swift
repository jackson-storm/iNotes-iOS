import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    func savePassword(_ password: String, forKey key: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }

        let query: [String: Any] = [
            kSecClass as String:             kSecClassGenericPassword,
            kSecAttrAccount as String:      key,
            kSecValueData as String:        passwordData,
            kSecAttrAccessible as String:   kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getPassword(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:     key,
            kSecReturnData as String:      true,
            kSecMatchLimit as String:      kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess,
           let data = result as? Data,
           let password = String(data: data, encoding: .utf8) {
            return password
        }
        return nil
    }

    func deletePassword(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String:        kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}


final class CreatePasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var useBiometrics: Bool = true
    @Published var errorMessage: String? = nil
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false

    private let keychainKey = "user_password"

    func validateAndSave(completion: @escaping () -> Void) {
        errorMessage = nil

        guard !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Fields cannot be empty"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        let success = KeychainManager.shared.savePassword(password, forKey: keychainKey)
        if success {
            UserDefaults.standard.set(true, forKey: "isPasswordCreated")
            completion()
        } else {
            errorMessage = "Failed to save password"
        }
    }

    func isPasswordCorrect(_ input: String) -> Bool {
        guard let saved = KeychainManager.shared.getPassword(forKey: keychainKey) else {
            return false
        }
        return saved == input
    }
}
