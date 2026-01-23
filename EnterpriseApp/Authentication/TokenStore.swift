//
//  TokenStore.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import Foundation

public struct AuthTokens: Sendable, Equatable {
    public let accessToken: String
    public let refreshToken: String?
    public let expiresAt: Date?

    public init(accessToken: String, refreshToken: String? = nil, expiresAt: Date? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}

public protocol TokenStore: Sendable {
    func read() async -> AuthTokens?
    func write(_ tokens: AuthTokens?) async
}

public actor InMemoryTokenStore: TokenStore {
    private var tokens: AuthTokens?

    public init(initial: AuthTokens? = nil) {
        self.tokens = initial
    }

    public func read() async -> AuthTokens? {
        tokens
    }

    public func write(_ tokens: AuthTokens?) async {
        self.tokens = tokens
    }
}
