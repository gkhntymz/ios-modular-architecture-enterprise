//
//  AuthNetworkError+Mapping.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 19.01.2026.
//

import Foundation
import FeatureAuthentication

extension AuthNetworkError {
    static func from(_ appError: AppNetworkError) -> AuthNetworkError {
        switch appError {
        case .offline: return .offline
        case .timeout: return .timeout
        case .cancelled: return .cancelled
        case .unauthorized: return .unauthorized
        case .forbidden: return .forbidden
        case .notFound: return .notFound
        case .server: return .server
        case .decoding: return .decoding
        case .unknown: return .unknown
        }
    }
}
