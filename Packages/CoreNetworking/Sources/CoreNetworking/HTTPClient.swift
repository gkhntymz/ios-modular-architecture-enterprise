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
    private let interceptorPipeline: InterceptorPipeline?

    public init(
        session: URLSession = .shared,
        interceptorPipeline: InterceptorPipeline? = nil
    ) {
        self.session = session
        self.interceptorPipeline = interceptorPipeline
    }

    public func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let context = InterceptorContext()

        var interceptedRequest = request
        if let pipeline = interceptorPipeline {
            interceptedRequest = try await pipeline.processRequest(interceptedRequest, context: context)
        }

        let (data, response) = try await session.data(for: interceptedRequest)

        guard let http = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        // Let interceptors observe the response before we throw on status code.
        if let pipeline = interceptorPipeline {
            try await pipeline.processResponse(http, data: data, context: context)
        }

        // Baseline: accept 200–299 only
        guard (200...299).contains(http.statusCode) else {
            throw HTTPClientError.unacceptableStatusCode(http.statusCode)
        }

        return (data, http)
    }
}
