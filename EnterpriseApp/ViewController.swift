//
//  ViewController.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 14.01.2026.
//

import UIKit
import CoreNetworking
import FeatureAuthentication
import CoreLogging

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let logger = ConsoleLogger()
        let logger = OSLogLogger(
            subsystem: Bundle.main.bundleIdentifier ?? "ios-modular-enterprise",
            category: "networking",
            minimumLevel: .info
        )
        
//        let pipeline = InterceptorPipeline([
//            RequestIDInterceptor(),
//            LoggingInterceptor(logger: logger),
//            MetricsInterceptor(metrics: metrics),
//            AuthorizationInterceptor(tokenProvider: { "demo-token" })
//        ])

        
        // 1) Interceptors (cross-cutting concerns)
        let metrics = ConsoleMetricsSink()
        let tokenStore = InMemoryTokenStore()

        let pipeline = InterceptorPipeline([
            RequestIDInterceptor(),
            LoggingInterceptor(logger: logger),
            MetricsInterceptor(metrics: metrics),
            AuthorizationInterceptor(tokenProvider: { await tokenStore.read()?.accessToken })
        ])

        // 2) Retry policy (resilience)
        let retryPolicy = ExponentialBackoffRetryPolicy(
            maxAttempts: 3,
            baseDelay: 0.25,
            maxDelay: 2.0
        )

        // 3) HTTP client wired with pipeline + retry
        let client = URLSessionHTTPClient(
            interceptorPipeline: pipeline,
            retryPolicy: retryPolicy
        )

        // 4) Feature service
        let service = AuthService(
            client: client,
            builder: RequestBuilder(baseURL: URL(string: "https://api.example.com")!),
            networkErrorMapper: AuthNetworkErrorMapper { error in
                AuthNetworkError.from(AppNetworkError.map(error))
            }
        )

        // 5)call
        Task {
            do {
                let response = try await service.login(.init(email: "a@b.com", password: "x"))

                await tokenStore.write(.init(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    expiresAt: response.expiresIn.map { Date().addingTimeInterval(TimeInterval($0)) }
                ))

                print("Login success: token stored")
            } catch {
                print("Auth error:", error)
            }
        }
    }
}
