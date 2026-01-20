//
//  RetryContext.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public struct RetryContext: Sendable {
    public let attempt: Int
    public let method: HTTPMethod
    public let url: URL?
    public let requestID: UUID

    public init(attempt: Int, method: HTTPMethod, url: URL?, requestID: UUID) {
        self.attempt = attempt
        self.method = method
        self.url = url
        self.requestID = requestID
    }
}
