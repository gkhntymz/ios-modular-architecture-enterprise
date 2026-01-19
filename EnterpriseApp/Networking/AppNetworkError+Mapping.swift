//
//  AppNetworkError+Mapping.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 19.01.2026.
//

import Foundation
import CoreNetworking

extension AppNetworkError {
    static func map(_ error: Error) -> AppNetworkError {
        // 1) CoreNetworkingError (decoding/build)
        if let e = error as? CoreNetworkingError {
            switch e {
            case .decodingFailed:
                return .decoding
            case .requestBuildFailed:
                return .unknown
            }
        }

        // 2) HTTPClientError (status code)
        if let e = error as? HTTPClientError {
            switch e {
            case .invalidResponse:
                return .unknown
            case .unacceptableStatusCode(let code):
                switch code {
                case 401: return .unauthorized
                case 403: return .forbidden
                case 404: return .notFound
                case 500...599: return .server
                default: return .unknown
                }
            }
        }

        // 3) URLError (connectivity/timeout/etc)
        if let urlError = (error as? URLError) ?? (error as NSError).asURLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .offline
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                return .unknown
            }
        }

        return .unknown
    }
}

private extension NSError {
    var asURLError: URLError? {
        guard domain == NSURLErrorDomain else { return nil }
        return URLError(URLError.Code(rawValue: code))
    }
}
