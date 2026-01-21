//
//  InterceptorContext.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public struct InterceptorContext: Sendable {
    public let requestID: UUID
    public let startTime: Date
    public let attempt: Int

    public init(
        requestID: UUID = UUID(),
        startTime: Date = Date(),
        attempt: Int = 1
    ) {
        self.requestID = requestID
        self.startTime = startTime
        self.attempt = attempt
    }

    public func withAttempt(_ attempt: Int) -> InterceptorContext {
        .init(requestID: requestID, startTime: startTime, attempt: attempt)
    }
}
