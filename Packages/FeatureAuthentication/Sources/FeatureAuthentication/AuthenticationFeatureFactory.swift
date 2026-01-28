//
//  AuthenticationFeatureFactory.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

/// Factory responsible for creating AuthenticationFeature instances.
///
/// App layer must use this factory instead of concrete implementations.
public enum AuthenticationFeatureFactory {

    public static func make() -> AuthenticationFeature {
        AuthenticationFeatureImpl()
    }
}
