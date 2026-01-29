//
//  AppCoordinator.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 29.01.2026.
//
import UIKit
import FeatureAuthentication

final class AppCoordinator: AuthCoordinating {
    private let nav: UINavigationController
    private let makeAuth: (_ output: AuthenticationOutput) -> UIViewController
    private let makeProfile: (_ output: ProfileOutput) -> UIViewController

    init(
        nav: UINavigationController,
        makeAuth: @escaping (_ output: AuthenticationOutput) -> UIViewController,
        makeProfile: @escaping (_ output: ProfileOutput) -> UIViewController
    ) {
        self.nav = nav
        self.makeAuth = makeAuth
        self.makeProfile = makeProfile
    }

    func start() {
        showAuth()
    }

    private func showAuth() {
        let output = AuthenticationOutput(
            onAuthenticated: { [weak self] in self?.showProfile() },
            onLogout: { [weak self] in self?.showAuth() }
        )
        nav.setViewControllers([makeAuth(output)], animated: false)
    }

    private func showProfile() {
        print("✅ Coordinator: showProfile()")
        let output = ProfileOutput(
            onLogout: { [weak self] in self?.showAuth() }
        )
        nav.setViewControllers([makeProfile(output)], animated: true)
    }
    
    func handleAuthenticated() {
        
    }
    
    func handleLogout() {
           
    }
}
