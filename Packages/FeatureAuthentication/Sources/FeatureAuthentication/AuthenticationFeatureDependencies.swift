//
//  AuthenticationFeatureDependencies.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

// FeatureAuthentication

import Foundation
import CoreNetworking
import CoreLogging

public struct AuthenticationFeatureDependencies: Sendable {
    public let client: any HTTPClient
    public let requestBuilder: RequestBuilder
    public let logger: any Logger

    /// App supplies this mapping (App-level mapping -> Feature-level user-facing error)
    public let mapNetworkError: @Sendable (Error) -> AuthNetworkError

    public init(
        client: any HTTPClient,
        requestBuilder: RequestBuilder,
        logger: any Logger,
        mapNetworkError: @escaping @Sendable (Error) -> AuthNetworkError
    ) {
        self.client = client
        self.requestBuilder = requestBuilder
        self.logger = logger
        self.mapNetworkError = mapNetworkError
    }
}
