//
//  ProfileViewController.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 29.01.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let feature: ProfileFeature

    init(feature: ProfileFeature) {
        self.feature = feature
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
    }

    @objc private func didTapLogout() {
        feature.logout()
    }
}
