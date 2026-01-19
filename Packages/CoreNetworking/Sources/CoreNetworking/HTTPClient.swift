import Foundation

public protocol HTTPClient: Sendable {
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

public enum HTTPClientError: Error, Equatable {
    case invalidResponse
    case unacceptableStatusCode(Int)
}


public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        // Baseline: accept 200–299 only
        guard (200...299).contains(http.statusCode) else {
            throw HTTPClientError.unacceptableStatusCode(http.statusCode)
        }

        return (data, http)
    }
}
