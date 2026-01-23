//
//  AuthorizationInterceptor.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public struct AuthorizationInterceptor: RequestInterceptor {
    public typealias TokenProvider = @Sendable () async -> String?

    private let tokenProvider: TokenProvider

    public init(tokenProvider: @escaping TokenProvider) {
        self.tokenProvider = tokenProvider
    }

    // REQUIRED by RequestInterceptor
    public func intercept(_ request: URLRequest, context: InterceptorContext) async throws -> URLRequest {
        var req = request
        if let token = await tokenProvider() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return req
    }

    // REQUIRED by RequestInterceptor (no-op)
    public func intercept(_ response: HTTPURLResponse, data: Data, context: InterceptorContext) async throws {
        // no-op
    }

    // REQUIRED by RequestInterceptor (no-op)
    public func intercept(_ error: Error, context: InterceptorContext) async {
        // no-op
    }
}
