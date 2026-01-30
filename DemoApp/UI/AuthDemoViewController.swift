//
//  AuthDemoViewController.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 29.01.2026.
//
import UIKit
import FeatureAuthentication

final class AuthDemoViewController: UIViewController {
    private let output: AuthenticationOutput

    init(output: AuthenticationOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let button = UIButton(type: .system)
        button.setTitle("Simulate Login Success", for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func login() {
        output.onAuthenticated?()
    }
}
