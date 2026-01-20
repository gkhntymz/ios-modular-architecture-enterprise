//
//  ViewController.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 14.01.2026.
//

import UIKit
import CoreNetworking
import FeatureAuthentication

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1) Interceptors (cross-cutting concerns)
        let pipeline = InterceptorPipeline([
            RequestIDInterceptor(),
            AuthorizationInterceptor(tokenProvider: { "demo-token" })
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

        // 5) Demo call
        Task {
            do {
                _ = try await service.login(LoginRequest(email: "a@b.com", password: "x"))
                print("Login success (demo)")
            } catch {
                print("Auth error:", error)
            }
        }
    }
}
