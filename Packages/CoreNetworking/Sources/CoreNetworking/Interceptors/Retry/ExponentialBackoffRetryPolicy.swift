//
//  ExponentialBackoffRetryPolicy.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public struct ExponentialBackoffRetryPolicy: RetryPolicy, Sendable {
    public let maxAttempts: Int
    public let baseDelay: TimeInterval
    public let maxDelay: TimeInterval
    public let jitter: ClosedRange<Double>
    public let retryableStatusCodes: Set<Int>

    public init(
        maxAttempts: Int = 3,
        baseDelay: TimeInterval = 0.25,
        maxDelay: TimeInterval = 3.0,
        jitter: ClosedRange<Double> = 0.8...1.2,
        retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504]
    ) {
        self.maxAttempts = maxAttempts
        self.baseDelay = baseDelay
        self.maxDelay = maxDelay
        self.jitter = jitter
        self.retryableStatusCodes = retryableStatusCodes
    }

    public func decision(for error: Error, context: RetryContext) -> RetryDecision {
        // Attempts are 1-based externally (attempt 1 is first try)
        guard context.attempt < maxAttempts else { return .doNotRetry }

        // Never retry cancellation
        if error is CancellationError { return .doNotRetry }
        if (error as NSError).domain == NSURLErrorDomain,
           (error as NSError).code == NSURLErrorCancelled {
            return .doNotRetry
        }

        // Only retry idempotent methods by default
        guard isIdempotent(context.method) else { return .doNotRetry }

        // Retry based on HTTP status codes (from our HTTPClientError)
        if case HTTPClientError.unacceptableStatusCode(let code) = error,
           retryableStatusCodes.contains(code) {
            return .retry(after: backoffDelay(attempt: context.attempt))
        }

        // Retry selected transport errors
        if shouldRetryTransportError(error) {
            return .retry(after: backoffDelay(attempt: context.attempt))
        }

        return .doNotRetry
    }

    private func isIdempotent(_ method: HTTPMethod) -> Bool {
        switch method {
        case .get, .put, .delete:
            return true
        case .post, .patch:
            return false
        }
    }

    private func shouldRetryTransportError(_ error: Error) -> Bool {
        let ns = error as NSError
        guard ns.domain == NSURLErrorDomain else { return false }

        switch ns.code {
        case NSURLErrorTimedOut,
             NSURLErrorCannotFindHost,
             NSURLErrorCannotConnectToHost,
             NSURLErrorNetworkConnectionLost,
             NSURLErrorNotConnectedToInternet,
             NSURLErrorDNSLookupFailed:
            return true
        default:
            return false
        }
    }

    private func backoffDelay(attempt: Int) -> TimeInterval {
        // attempt: 1 (first try) -> delay based on 2^(attempt-1)
        let exp = pow(2.0, Double(attempt - 1))
        let raw = min(maxDelay, baseDelay * exp)
        let factor = Double.random(in: jitter)
        return raw * factor
    }
}
