//
//  LoggingInterceptor.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 21.01.2026.
//

import Foundation
import CoreLogging

public struct LoggingInterceptor: RequestInterceptor {
    private let logger: Logger
    private let redactor: Redactor
    private let classifier: NetworkTransportErrorClassifier

    public init(
        logger: Logger,
        redactor: Redactor = DefaultRedactor(),
        classifier: NetworkTransportErrorClassifier = .init()
    ) {
        self.logger = logger
        self.redactor = redactor
        self.classifier = classifier
    }

    public func intercept(_ request: URLRequest, context: InterceptorContext) async throws -> URLRequest {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "<nil>"

        let headers = (request.allHTTPHeaderFields ?? [:])
            .map { key, value in "\(key): \(redactor.redactHeader(name: key, value: value))" }
            .sorted()
            .joined(separator: ", ")

        logger.log(.info, "HTTP request", metadata: [
            "request_id": context.requestID.uuidString,
            "attempt": "\(context.attempt)",
            "method": method,
            "url": url,
            "headers": headers
        ])

        return request
    }

    public func intercept(_ response: HTTPURLResponse, data: Data, context: InterceptorContext) async throws {
        let durationMs = Int(Date().timeIntervalSince(context.startTime) * 1000)

        logger.log(.info, "HTTP response", metadata: [
            "request_id": context.requestID.uuidString,
            "attempt": "\(context.attempt)",
            "status": "\(response.statusCode)",
            "duration_ms": "\(durationMs)",
            "bytes": "\(data.count)"
        ])
    }

    // ✅ NEW: required by RequestInterceptor
    public func intercept(_ error: Error, context: InterceptorContext) async {
        let category = classifier.classify(error).rawValue
        logger.log(.error, "HTTP transport error", metadata: [
            "request_id": context.requestID.uuidString,
            "attempt": "\(context.attempt)",
            "category": category,
            "error": String(describing: error)
        ])
    }
}
