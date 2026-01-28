//
//  AuthenticationFeature.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

/// Public entry point for Authentication feature.
///
/// Feature layer exposes intent & flow,
/// not UIKit / SwiftUI types.
public protocol AuthenticationFeature {

    /// Starts authentication flow.
    func startAuthentication()
}
