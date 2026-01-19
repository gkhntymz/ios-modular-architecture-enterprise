//
//  ViewController.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 14.01.2026.
//

import UIKit
import FeatureAuthentication
import CoreNetworking

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Compile-time smoke-check
//        _ = URLSessionHTTPClient()
//
//        // User-facing error mapping smoke-check
//        let sampleError = URLError(.notConnectedToInternet)
//        let appError = AppNetworkError.map(sampleError)
//
//        print("DEBUG ERROR:", sampleError)
//        print("USER MESSAGE:", appError.userMessage)
        
        let service = AuthService(
            client: URLSessionHTTPClient(),
            builder: RequestBuilder(baseURL: URL(string: "https://api.example.com")!),
            networkErrorMapper: AuthNetworkErrorMapper { error in
                AuthNetworkError.from(AppNetworkError.map(error))
            }
        )

        Task {
            do {
                _ = try await service.login(.init(email: "a@b.com", password: "x"))
                print("Login success (demo)")
            } catch {
                print("Auth error:", error)
            }
        }
    }
}
