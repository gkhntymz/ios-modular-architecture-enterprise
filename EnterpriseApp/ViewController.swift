//
//  ViewController.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 14.01.2026.
//

import UIKit
import FeatureAuthentication
import CoreNetworking
import CoreLogging

final class ViewController: UIViewController {
    
    private let authFeature = AuthComposition.makeAuthFeature()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let button = UIButton(type: .system)
        button.setTitle("Start Authentication", for: .normal)
        button.addTarget(self, action: #selector(didTapAuth), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapAuth() {
        Task { @MainActor in
            await authFeature.startAuthentication()
        }
    }
}

