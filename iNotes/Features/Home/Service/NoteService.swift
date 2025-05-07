import Foundation

final class NoteService {
    static let shared = NoteService()
    private init() {}

    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    func fetchNotes(completion: @escaping (Result<[Note], NetworkError>) -> Void) {
        let url = ServiceURL.shared.notesURL
        let task = session.dataTask(with: url) { data, response, error in
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
                let notes = try self.jsonDecoder.decode([Note].self, from: data)
                completion(.success(notes))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }

    func fetchNote(id: UUID, completion: @escaping (Result<Note, NetworkError>) -> Void) {
        let url = ServiceURL.shared.notesURL.appendingPathComponent(id.uuidString)
        let task = session.dataTask(with: url) { data, response, error in
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
                let note = try self.jsonDecoder.decode(Note.self, from: data)
                completion(.success(note))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }

    func createNote(_ note: Note, completion: @escaping (Result<Note, NetworkError>) -> Void) {
        var request = URLRequest(url: ServiceURL.shared.notesURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let body = try jsonEncoder.encode(note)
            request.httpBody = body
        } catch {
            return completion(.failure(.decodingFailed(error)))
        }

        let task = session.dataTask(with: request) { data, response, error in
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
                let created = try self.jsonDecoder.decode(Note.self, from: data)
                completion(.success(created))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }

    func updateNote(_ note: Note, completion: @escaping (Result<Note, NetworkError>) -> Void) {
        let url = ServiceURL.shared.notesURL.appendingPathComponent(note.id.uuidString)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let body = try jsonEncoder.encode(note)
            request.httpBody = body
        } catch {
            return completion(.failure(.decodingFailed(error)))
        }

        let task = session.dataTask(with: request) { data, response, error in
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
                let updated = try self.jsonDecoder.decode(Note.self, from: data)
                completion(.success(updated))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }

    func deleteNote(id: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let url = ServiceURL.shared.notesURL.appendingPathComponent(id.uuidString)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = session.dataTask(with: request) { _, response, error in
            if let error = error {
                return completion(.failure(.requestFailed(error)))
            }
            guard let http = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }
            guard (200..<300).contains(http.statusCode) else {
                return completion(.failure(.serverError(statusCode: http.statusCode)))
            }
            completion(.success(()))
        }
        task.resume()
    }
}
