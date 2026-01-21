//
//  NetworkTransportError.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 21.01.2026.
//

import Foundation

public enum NetworkTransportError: String, Sendable {
    case cancelled
    case offline
    case timeout
    case dns
    case cannotConnect
    case connectionLost
    case tls
    case unknown
}

public struct NetworkTransportErrorClassifier: Sendable {
    public init() {}

    public func classify(_ error: Error) -> NetworkTransportError {
        if error is CancellationError { return .cancelled }

        let ns = error as NSError
        guard ns.domain == NSURLErrorDomain else { return .unknown }

        switch ns.code {
        case NSURLErrorCancelled:
            return .cancelled
        case NSURLErrorNotConnectedToInternet:
            return .offline
        case NSURLErrorTimedOut:
            return .timeout
        case NSURLErrorDNSLookupFailed, NSURLErrorCannotFindHost:
            return .dns
        case NSURLErrorCannotConnectToHost:
            return .cannotConnect
        case NSURLErrorNetworkConnectionLost:
            return .connectionLost
        case NSURLErrorSecureConnectionFailed,
             NSURLErrorServerCertificateUntrusted,
             NSURLErrorServerCertificateHasBadDate,
             NSURLErrorServerCertificateHasUnknownRoot,
             NSURLErrorServerCertificateNotYetValid,
             NSURLErrorClientCertificateRejected,
             NSURLErrorClientCertificateRequired:
            return .tls
        default:
            return .unknown
        }
    }
}
