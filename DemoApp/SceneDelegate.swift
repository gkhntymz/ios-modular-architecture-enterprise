//
//  SceneDelegate.swift
//  DemoApp
//
//  Created by Gökhan Taymaz on 30.01.2026.
//

import UIKit
import FeatureAuthentication

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        // Root navigation
        let nav = UINavigationController()
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window

        // Coordinator wiring (demo)
        coordinator = AppCoordinator(
            nav: nav,
            makeAuth: { output in
                AuthDemoViewController(output: output)
            },
            makeProfile: { output in
                ProfileDemoViewController(output: output)
            }
        )

        coordinator?.start()
    }
}
