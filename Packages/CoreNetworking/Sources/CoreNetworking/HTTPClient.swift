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
        let baseContext = InterceptorContext()
        let method = HTTPMethod(rawValue: request.httpMethod ?? "GET") ?? .get

        var attempt = 1

        while true {
            try Task.checkCancellation()

            let context = baseContext.withAttempt(attempt)

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
                // ✅ NEW: let interceptors observe transport/errors too
                if let pipeline = interceptorPipeline {
                    await pipeline.processError(error, context: context)
                }

                guard let policy = retryPolicy else { throw error }

                let retryContext = RetryContext(
                    attempt: attempt,
                    method: method,
                    url: request.url,
                    requestID: baseContext.requestID
                )

                switch policy.decision(for: error, context: retryContext) {
                case .doNotRetry:
                    throw error
                case .retry(let delay):
                    attempt += 1
                    try Task.checkCancellation()
                    let nanos = UInt64(max(0, delay) * 1_000_000_000)
                    try await Task.sleep(nanoseconds: nanos)
                    continue
                }
            }
        }
    }
}
