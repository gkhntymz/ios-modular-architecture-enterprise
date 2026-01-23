//
//  MockHTTPClient.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import Foundation
import CoreNetworking

struct MockHTTPClient: HTTPClient {
    let handler: @Sendable (URLRequest) async throws -> (Data, HTTPURLResponse)

    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try await handler(request)
    }
}

struct FailingHTTPClient: HTTPClient {
    let error: Error

    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        throw error
    }
}
