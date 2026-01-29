//
//  AuthenticationFeatureFactory.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

/// Factory responsible for creating AuthenticationFeature instances.
///
/// App layer must use this factory instead of concrete implementations.
import Foundation
import CoreNetworking
import CoreLogging

public enum AuthenticationFeatureFactory {

    public static func make(
        dependencies deps: AuthenticationFeatureDependencies,
        output: AuthenticationOutput = .init()
    ) -> AuthenticationFeature {

        let service = AuthService(
            client: deps.client,
            builder: deps.requestBuilder,
            networkErrorMapper: AuthNetworkErrorMapper(map: deps.mapNetworkError)
        )

        return DefaultAuthenticationFeature(
            service: service,
            logger: deps.logger,
            output: output
        )
    }
}
