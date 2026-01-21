//
//  InterceptorPipeline.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public struct InterceptorPipeline: Sendable {
    private let interceptors: [RequestInterceptor]

    public init(_ interceptors: [RequestInterceptor]) {
        self.interceptors = interceptors
    }

    public func processRequest(
        _ request: URLRequest,
        context: InterceptorContext
    ) async throws -> URLRequest {
        var req = request
        for interceptor in interceptors {
            req = try await interceptor.intercept(req, context: context)
        }
        return req
    }

    public func processResponse(
        _ response: HTTPURLResponse,
        data: Data,
        context: InterceptorContext
    ) async throws {
        for interceptor in interceptors {
            try await interceptor.intercept(response, data: data, context: context)
        }
    }
    
    public func processError(_ error: Error, context: InterceptorContext) async {
        for interceptor in interceptors {
            await interceptor.intercept(error, context: context)
        }
    }
}

