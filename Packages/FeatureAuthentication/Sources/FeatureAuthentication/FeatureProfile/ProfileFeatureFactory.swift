//
//  ProfileFeatureFactory.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 29.01.2026.
//

import UIKit

public enum ProfileFeatureFactory {

    @MainActor
    public static func make(output: ProfileOutput) -> UIViewController {
        let feature = DefaultProfileFeature(output: output)
        return ProfileViewController(feature: feature)
    }
}
