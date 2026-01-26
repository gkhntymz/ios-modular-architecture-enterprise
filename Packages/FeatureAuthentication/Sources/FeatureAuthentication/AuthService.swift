//
//  AuthService.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 19.01.2026.
//
import Foundation
import CoreNetworking

public enum AuthError: Error, Equatable, Sendable {
    case invalidCredentials
    case sessionExpired
    case network(AuthNetworkError)
    case unknown
}

/// Feature-level, user-facing network error categorization.
/// App layer can map its own `AppNetworkError` into this type.
public enum AuthNetworkError: Equatable, Sendable {
    case offline
    case timeout
    case cancelled
    case unauthorized
    case forbidden
    case notFound
    case server
    case decoding
    case unknown
}

public struct AuthNetworkErrorMapper: Sendable {
    public let map: @Sendable (Error) -> AuthNetworkError
    public init(map: @escaping @Sendable (Error) -> AuthNetworkError) { self.map = map }
}

public struct AuthService: Sendable {
    private let client: any HTTPClient
    private let builder: RequestBuilder
    private let networkErrorMapper: AuthNetworkErrorMapper

    public init(
        client: any HTTPClient,
        builder: RequestBuilder,
        networkErrorMapper: AuthNetworkErrorMapper
    ) {
        self.client = client
        self.builder = builder
        self.networkErrorMapper = networkErrorMapper
    }

    public func login(_ request: LoginRequest) async throws -> LoginResponse {
        do {
            let endpoint = try AuthEndpoints.login(request)
            return try await client.send(endpoint, using: builder)
        } catch let e as HTTPClientError {
            if case .unacceptableStatusCode(let code) = e, code == 401 {
                throw AuthError.invalidCredentials
            }
            throw AuthError.network(networkErrorMapper.map(e))
        } catch {
            throw AuthError.network(networkErrorMapper.map(error))
        }
    }
    
    public func me() async throws -> ProfileResponse {
        do {
            let endpoint = try AuthEndpoints.me()
            return try await client.send(endpoint, using: builder)

        } catch let e as HTTPClientError {
            if case .unacceptableStatusCode(let code) = e, code == 401 {
                throw AuthError.sessionExpired
            }
            throw AuthError.network(networkErrorMapper.map(e))

        } catch {
            throw AuthError.network(networkErrorMapper.map(error))
        }
    }
}
