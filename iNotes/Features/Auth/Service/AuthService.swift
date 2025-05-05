import Foundation

class AuthService {
    static let shared = AuthService()
    private init() {}

    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        sendRequest(url: ServiceURL.shared.authRegisterUrl, method: "POST", body: request, completion: completion)
    }

    func login(request: LoginRequest, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        sendRequest(url: ServiceURL.shared.authLoginUrl, method: "POST", body: request, completion: completion)
    }

    private func sendRequest<T: Codable, R: Codable>(url: URL, method: String, body: T, completion: @escaping (Result<R, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -1)))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(R.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
