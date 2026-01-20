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

    public init(
        requestID: UUID = UUID(),
        startTime: Date = Date()
    ) {
        self.requestID = requestID
        self.startTime = startTime
    }
}
