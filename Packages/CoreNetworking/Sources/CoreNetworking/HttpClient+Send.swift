//
//  HttpClient+Send.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 18.01.2026.
//

import Foundation

public enum CoreNetworkingError: Error {
    case requestBuildFailed(underlying: Error)
    case decodingFailed(underlying: Error)
}

public extension HTTPClient {
    func send<Response>(
        _ endpoint: Endpoint<Response>,
        using builder: RequestBuilder
    ) async throws -> Response {
        let request: URLRequest
        do {
            request = try builder.makeRequest(for: endpoint)
        } catch {
            throw CoreNetworkingError.requestBuildFailed(underlying: error)
        }

        let (data, response) = try await self.data(for: request)

        do {
            return try endpoint.decode(data, response)
        } catch {
            throw CoreNetworkingError.decodingFailed(underlying: error)
        }
    }
}

extension CoreNetworkingError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .requestBuildFailed(let underlying):
            return "CoreNetworkingError.requestBuildFailed(underlying: \(underlying))"
        case .decodingFailed(let underlying):
            return "CoreNetworkingError.decodingFailed(underlying: \(underlying))"
        }
    }
}
