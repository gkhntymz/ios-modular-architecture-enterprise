//
//  AuthEndpoints.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 19.01.2026.
//

import Foundation
import CoreNetworking

enum AuthEndpoints {
    static func login(_ req: LoginRequest) throws -> Endpoint<LoginResponse> {
        struct Body: Encodable { let email: String; let password: String }

        let body = try JSONEncoder().encode(Body(email: req.email, password: req.password))

        return Endpoint<LoginResponse>.json(
            method: .post,
            path: "/v1/auth/login",
            headers: ["Content-Type": "application/json"],
            body: body
        )
    }
}
