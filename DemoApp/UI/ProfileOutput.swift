//
//  ProfileOutput.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 30.01.2026.
//

import Foundation

public struct ProfileOutput {
    public var onLogout: (() -> Void)?

    public init(onLogout: (() -> Void)? = nil) {
        self.onLogout = onLogout
    }
}
