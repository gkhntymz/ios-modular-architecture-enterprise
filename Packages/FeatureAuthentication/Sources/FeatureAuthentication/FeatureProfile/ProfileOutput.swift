//
//  ProfileOutput.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 29.01.2026.
//

public struct ProfileOutput: Sendable {
    public var onLogout: (@Sendable () -> Void)?

    public init(onLogout: (@Sendable () -> Void)? = nil) {
        self.onLogout = onLogout
    }
}
