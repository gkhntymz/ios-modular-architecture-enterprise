//
//  RequestIDInterceptor.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public struct RequestIDInterceptor: RequestInterceptor {

    public init() {}

    public func intercept(
        _ request: URLRequest,
        context: InterceptorContext
    ) async throws -> URLRequest {
        var r = request
        r.setValue(context.requestID.uuidString, forHTTPHeaderField: "X-Request-Id")
        return r
    }

    public func intercept(
        _ response: HTTPURLResponse,
        data: Data,
        context: InterceptorContext
    ) async throws { }
}
