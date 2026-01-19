//
//  LoginModel.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 19.01.2026.
//

import Foundation

public struct LoginRequest: Sendable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct LoginResponse: Decodable, Equatable, Sendable {
    public let accessToken: String
}
