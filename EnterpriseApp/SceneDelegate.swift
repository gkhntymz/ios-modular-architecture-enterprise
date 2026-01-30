//
//  SceneDelegate.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 14.01.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        // Production-like root (placeholder for now)
        let nav = UINavigationController(rootViewController: PlaceholderViewController())
        window.rootViewController = nav
        window.makeKeyAndVisible()

        self.window = window
    }
}


