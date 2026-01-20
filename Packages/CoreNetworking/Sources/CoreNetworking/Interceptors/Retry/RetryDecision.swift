//
//  RetryDecision.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public enum RetryDecision: Sendable, Equatable {
    case retry(after: TimeInterval)
    case doNotRetry
}
