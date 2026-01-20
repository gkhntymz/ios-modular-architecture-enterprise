//
//  AuthorizationInterceptor.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public struct AuthorizationInterceptor: RequestInterceptor {
    private let tokenProvider: @Sendable () async throws -> String

    public init(tokenProvider: @escaping @Sendable () async throws -> String) {
        self.tokenProvider = tokenProvider
    }

    public func intercept(
        _ request: URLRequest,
        context: InterceptorContext
    ) async throws -> URLRequest {
        var r = request
        let token = try await tokenProvider()
        r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return r
    }

    public func intercept(
        _ response: HTTPURLResponse,
        data: Data,
        context: InterceptorContext
    ) async throws { }
}
