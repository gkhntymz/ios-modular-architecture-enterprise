//
//  MetricsInterceptor.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import Foundation
import CoreLogging

public struct MetricsInterceptor: RequestInterceptor {
    private let metrics: MetricsSink
    private let classifier: NetworkTransportErrorClassifier

    public init(
        metrics: MetricsSink,
        classifier: NetworkTransportErrorClassifier = .init()
    ) {
        self.metrics = metrics
        self.classifier = classifier
    }

    public func intercept(_ request: URLRequest, context: InterceptorContext) async throws -> URLRequest {
        // Count attempts (helps understand retry behavior)
        metrics.increment("http.attempt", tags: [
            "attempt": "\(context.attempt)",
            "method": request.httpMethod ?? "GET"
        ])
        return request
    }

    public func intercept(_ response: HTTPURLResponse, data: Data, context: InterceptorContext) async throws {
        let durationMs = Double(Date().timeIntervalSince(context.startTime) * 1000)

        metrics.record("http.duration", value: durationMs, unit: "ms", tags: [
            "status": "\(response.statusCode)",
            "attempt": "\(context.attempt)"
        ])

        metrics.increment("http.response", tags: [
            "status": "\(response.statusCode)",
            "attempt": "\(context.attempt)"
        ])
    }

    public func intercept(_ error: Error, context: InterceptorContext) async {
        let category = classifier.classify(error).rawValue
        metrics.increment("http.error", tags: [
            "category": category,
            "attempt": "\(context.attempt)"
        ])
    }
}
