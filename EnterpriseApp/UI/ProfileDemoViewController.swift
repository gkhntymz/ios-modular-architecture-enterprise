//
//  ProfileDemoViewController.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 29.01.2026.
//

import UIKit
import FeatureAuthentication

final class ProfileDemoViewController: UIViewController {
    private let output: ProfileOutput

    init(output: ProfileOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"

        let label = UILabel()
        label.text = "✅ Logged in!"
        label.translatesAutoresizingMaskIntoConstraints = false

        let logout = UIButton(type: .system)
        logout.setTitle("Logout", for: .normal)
        logout.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        logout.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(logout)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            logout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logout.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16)
        ])
    }

    @objc private func didTapLogout() {
        output.onLogout?()
    }
}
