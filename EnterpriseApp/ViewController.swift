//
//  ViewController.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 14.01.2026.
//

import UIKit
import CoreNetworking

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Compile-time smoke-check
        _ = URLSessionHTTPClient()

        // User-facing error mapping smoke-check
        let sampleError = URLError(.notConnectedToInternet)
        let appError = AppNetworkError.map(sampleError)

        print("DEBUG ERROR:", sampleError)
        print("USER MESSAGE:", appError.userMessage)
    }
}
