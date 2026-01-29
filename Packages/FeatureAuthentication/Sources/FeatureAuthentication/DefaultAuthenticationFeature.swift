//
//  DefaultAuthenticationFeature.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

import Foundation
import CoreLogging

public final class DefaultAuthenticationFeature: AuthenticationFeature {
    private let service: AuthService
    private let logger: Logger
    private let output: AuthenticationOutput

    public init(service: AuthService, logger: Logger, output: AuthenticationOutput = .init()) {
        self.service = service
        self.logger = logger
        self.output = output
    }

    public func login(_ request: LoginRequest) async throws {
        let response = try await service.login(request)

        // token store vs. burada yapılacaksa burada kalsın (VC'den çıkarmış olacağız)

        output.onAuthenticated?()   // ⭐ event burada
        logger.info("Authenticated")
    }

    public func logout() {
        output.onLogout?()
        logger.info("Logged out")
    }
}
