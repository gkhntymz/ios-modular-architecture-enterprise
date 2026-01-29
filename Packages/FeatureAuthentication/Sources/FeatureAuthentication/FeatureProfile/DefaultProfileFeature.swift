//
//  DefaultProfileFeature.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 29.01.2026.
//

import Foundation

public final class DefaultProfileFeature: ProfileFeature {
    private let output: ProfileOutput

    public init(output: ProfileOutput) {
        self.output = output
    }

    public func logout() {
        output.onLogout?()
    }
}
