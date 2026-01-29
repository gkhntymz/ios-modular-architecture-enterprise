//
//  AuthenticationOutput.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 29.01.2026.
//

public struct AuthenticationOutput: Sendable {
    public var onAuthenticated: (@Sendable () -> Void)?
    public var onLogout: (@Sendable () -> Void)?

    public init(
        onAuthenticated: (@Sendable () -> Void)? = nil,
        onLogout: (@Sendable () -> Void)? = nil
    ) {
        self.onAuthenticated = onAuthenticated
        self.onLogout = onLogout
    }
}
