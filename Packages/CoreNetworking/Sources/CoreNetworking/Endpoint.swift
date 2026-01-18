//
//  Endpoint.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 18.01.2026.
//

import Foundation

public struct Endpoint<Response>: Sendable {
    public let method: HTTPMethod
    public let path: String
    public let queryItems: [URLQueryItem]
    public let headers: [String: String]
    public let body: Data?
    public let decode: @Sendable (Data, HTTPURLResponse) throws -> Response

    public init(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        decode: @escaping @Sendable (Data, HTTPURLResponse) throws -> Response
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.decode = decode
    }
}

public extension Endpoint where Response: Decodable {
    static func json(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Endpoint<Response> {
        Endpoint<Response>(
            method: method,
            path: path,
            queryItems: queryItems,
            headers: headers,
            body: body,
            decode: { data, _ in
                try decoder.decode(Response.self, from: data)
            }
        )
    }
}
