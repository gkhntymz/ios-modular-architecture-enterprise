//
//  RequestInterceptor.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 20.01.2026.
//

import Foundation

public protocol RequestInterceptor: Sendable {
    func intercept(_ request: URLRequest, context: InterceptorContext) async throws -> URLRequest
    func intercept(_ response: HTTPURLResponse, data: Data, context: InterceptorContext) async throws

    // NEW
    func intercept(_ error: Error, context: InterceptorContext) async
}

public extension RequestInterceptor {
    func intercept(_ error: Error, context: InterceptorContext) async { }
}
