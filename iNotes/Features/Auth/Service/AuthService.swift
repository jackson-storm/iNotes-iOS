import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}

    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()

    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        sendRequest(url: ServiceURL.shared.authRegisterUrl, method: "POST", body: request, completion: completion)
    }

    func login(request: LoginRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        sendRequest(url: ServiceURL.shared.authLoginUrl, method: "POST", body: request, completion: completion)
    }

    private func sendRequest<T: Codable, R: Codable>(url: URL, method: String, body: T, completion: @escaping (Result<R, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try jsonEncoder.encode(body)
        } catch {
            return completion(.failure(.decodingFailed(error)))
        }

        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    return completion(.failure(.requestFailed(error)))
                }
                guard let http = response as? HTTPURLResponse else {
                    return completion(.failure(.invalidResponse))
                }
                guard (200..<300).contains(http.statusCode) else {
                    return completion(.failure(.serverError(statusCode: http.statusCode)))
                }
                guard let data = data else {
                    return completion(.failure(.invalidResponse))
                }
                do {
                    let decoded = try self.jsonDecoder.decode(R.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decodingFailed(error)))
                }
            }
        }.resume()
    }
}
