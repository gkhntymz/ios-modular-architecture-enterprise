//
//  RequestBuilder.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 18.01.2026.
//

import Foundation

public enum RequestBuilderError: Error, Equatable {
    case invalidURL
}

public struct RequestBuilder: Sendable {
    private let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func makeRequest<Response>(for endpoint: Endpoint<Response>) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw RequestBuilderError.invalidURL
        }

        let sanitizedPath: String = {
            if endpoint.path.hasPrefix("/") { return endpoint.path }
            return "/" + endpoint.path
        }()

        components.path = (components.path as NSString).appendingPathComponent(sanitizedPath)
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw RequestBuilderError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        if !endpoint.headers.isEmpty {
            for (k, v) in endpoint.headers {
                request.setValue(v, forHTTPHeaderField: k)
            }
        }

        return request
    }
}
