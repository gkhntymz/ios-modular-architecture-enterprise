//
//  LoginResponse.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import Foundation

public struct LoginResponse: Decodable, Sendable, Equatable {
    public let accessToken: String
    public let refreshToken: String?
    public let expiresIn: Int?

    public init(accessToken: String, refreshToken: String?, expiresIn: Int?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}
