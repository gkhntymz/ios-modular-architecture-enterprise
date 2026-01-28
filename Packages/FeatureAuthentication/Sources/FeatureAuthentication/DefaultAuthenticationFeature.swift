//
//  DefaultAuthenticationFeature.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

import Foundation
import CoreLogging

final class DefaultAuthenticationFeature: AuthenticationFeature {
    private let service: AuthService
    private let logger: any Logger

    init(service: AuthService, logger: any Logger) {
        self.service = service
        self.logger = logger
    }

    func startAuthentication() async {
        logger.info("AuthFeature started")

        do {
            let response = try await service.login(.init(email: "a@b.com", password: "x"))
            logger.info("Login success: \(response.accessToken)")

            let me = try await service.me()
            logger.info("Me success: \(me)")
        } catch {
            logger.error("Auth error: \(String(describing: error))")
        }
    }
}
