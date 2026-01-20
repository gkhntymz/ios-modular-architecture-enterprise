//
//  RetryPolicy.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

public protocol RetryPolicy: Sendable {
    func decision(
        for error: Error,
        context: RetryContext
    ) -> RetryDecision
}
