//
//  AuthComposition.swift
//  EnterpriseApp
//
//  Composition root for Authentication feature.
//  App owns concrete implementations + policies (baseURL, retry, logging).
//
import Foundation
import FeatureAuthentication
import CoreNetworking
import CoreLogging

enum AuthComposition {

    static func makeAuthFeature(output: AuthenticationOutput = .init()) -> AuthenticationFeature {
        // 1) Logging
        let logger = OSLogLogger(
            subsystem: Bundle.main.bundleIdentifier ?? "ios-modular-enterprise",
            category: "auth",
            minimumLevel: .info
        )

        // 2) Cross-cutting: metrics + token store
        let metrics = ConsoleMetricsSink()
        let tokenStore = InMemoryTokenStore()

        // 3) Networking pipeline (interceptors)
        let pipeline = InterceptorPipeline([
            RequestIDInterceptor(),
            LoggingInterceptor(logger: logger),
            MetricsInterceptor(metrics: metrics),
            AuthorizationInterceptor(tokenProvider: { await tokenStore.read()?.accessToken })
        ])

        // 4) Resilience policy
        let retryPolicy = ExponentialBackoffRetryPolicy(
            maxAttempts: 3,
            baseDelay: 0.25,
            maxDelay: 2.0
        )

        // 5) Concrete client
        let client = URLSessionHTTPClient(
            interceptorPipeline: pipeline,
            retryPolicy: retryPolicy
        )

        // 6) Request builder policy (base URL belongs to App)
        let requestBuilder = RequestBuilder(baseURL: URL(string: "https://api.example.com")!)

        // 7) Error mapping policy (App maps Core errors -> Feature user-facing categories)
        let deps = AuthenticationFeatureDependencies(
            client: client,
            requestBuilder: requestBuilder,
            logger: logger,
            mapNetworkError: { error in
                Self.mapNetworkError(error)
            }
        )

        return AuthenticationFeatureFactory.make(
            dependencies: deps,
            output: output
        )
    }

    // MARK: - App-level error mapping

    private static func mapNetworkError(_ error: Error) -> AuthNetworkError {
        // 1) System / connectivity
        if let e = error as? URLError {
            switch e.code {
            case .notConnectedToInternet:
                return .offline
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                return .unknown
            }
        }

        // 2) HTTP-level errors
        if let e = error as? HTTPClientError {
            switch e {
            case .unacceptableStatusCode(let code):
                switch code {
                case 401: return .unauthorized
                case 403: return .forbidden
                case 404: return .notFound
                case 500...599: return .server
                default: return .unknown
                }
            default:
                return .unknown
            }
        }

        // 3) Decoding
        if error is DecodingError {
            return .decoding
        }

        return .unknown
    }
}
