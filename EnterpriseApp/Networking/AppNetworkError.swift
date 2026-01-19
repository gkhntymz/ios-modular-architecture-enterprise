//
//  AppNetworkError.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 19.01.2026.
//

public enum AppNetworkError: Error, Equatable {
    case offline
    case timeout
    case cancelled
    case unauthorized
    case forbidden
    case notFound
    case server
    case decoding
    case unknown
}

extension AppNetworkError {
    var userMessage: String {
        switch self {
        case .offline:
            return "Please check your internet connection."
        case .timeout:
            return "The request timed out. Please try again."
        case .cancelled:
            return "The operation was cancelled."
        case .unauthorized:
            return "Your session may have expired. Please sign in again."
        case .forbidden:
            return "You don’t have permission to perform this action."
        case .notFound:
            return "The requested resource could not be found."
        case .server:
            return "A server error occurred. Please try again later."
        case .decoding:
            return "An unexpected data error occurred."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}
