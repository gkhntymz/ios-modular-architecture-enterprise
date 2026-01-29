//
//  AuthenticationFeature.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

public protocol AuthenticationFeature {
    func login(_ request: LoginRequest) async throws
    func logout()
}
