import Foundation

final class ServiceURL {
    static let shared = ServiceURL()

    private init() {}

    private let baseURL = URL(string: "http://localhost:4200/api")!

    var authRegisterUrl: URL {
        baseURL.appendingPathComponent("auth/register")
    }

    var authLoginUrl: URL {
        baseURL.appendingPathComponent("auth/login")
    }
}
