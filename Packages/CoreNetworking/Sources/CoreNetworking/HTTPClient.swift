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

    private let retryPolicy: (any RetryPolicy)?

    public init(
        session: URLSession = .shared,
        interceptorPipeline: InterceptorPipeline? = nil,
        retryPolicy: (any RetryPolicy)? = nil
    ) {
        self.session = session
        self.interceptorPipeline = interceptorPipeline
        self.retryPolicy = retryPolicy
    }

    public func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let context = InterceptorContext()
        let method = HTTPMethod(rawValue: request.httpMethod ?? "GET") ?? .get

        var attempt = 1
        var lastError: Error?

        while true {
            try Task.checkCancellation()

            do {
                var interceptedRequest = request
                if let pipeline = interceptorPipeline {
                    interceptedRequest = try await pipeline.processRequest(interceptedRequest, context: context)
                }

                let (data, response) = try await session.data(for: interceptedRequest)

                guard let http = response as? HTTPURLResponse else {
                    throw HTTPClientError.invalidResponse
                }

                if let pipeline = interceptorPipeline {
                    try await pipeline.processResponse(http, data: data, context: context)
                }

                guard (200...299).contains(http.statusCode) else {
                    throw HTTPClientError.unacceptableStatusCode(http.statusCode)
                }

                return (data, http)
            } catch {
                lastError = error

                // Decide retry
                guard let policy = retryPolicy else { throw error }

                let retryContext = RetryContext(
                    attempt: attempt,
                    method: method,
                    url: request.url,
                    requestID: context.requestID
                )

                switch policy.decision(for: error, context: retryContext) {
                case .doNotRetry:
                    throw error
                case .retry(let delay):
                    attempt += 1
                    try Task.checkCancellation()
                    // Sleep expects nanoseconds
                    let nanos = UInt64(max(0, delay) * 1_000_000_000)
                    try await Task.sleep(nanoseconds: nanos)
                    continue
                }
            }
        }
    }
}
