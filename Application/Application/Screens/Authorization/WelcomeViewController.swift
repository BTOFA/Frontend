//
//  WelcomeScreenViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 18.04.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let signWithWalletButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    // MARK: - viewDidLoad function.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - viewWillAppear function.

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
    }
    
    // MARK: - Setup StatusBar.
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Setup iOS theme.
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
    }
    
    // MARK: - Setup Views.
    
    private func setupViews() {
        setupTitleLabeL()
        setupSignWithWalletButton()
    }
    
    // MARK: - Setup Views.
    
    private func setupTitleLabeL() {
        view.addSubview(titleLabel)
        titleLabel.pinCenterY(to: view)
        titleLabel.pinLeft(to: view, 16)
        titleLabel.text = "Blockchain\nTokenization of\nFinantial Assets"
        titleLabel.numberOfLines = .zero
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private func setupSignWithWalletButton() {
        view.addSubview(signWithWalletButton)
        signWithWalletButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 75)
        signWithWalletButton.pinLeft(to: view, 16)
        signWithWalletButton.pinRight(to: view, 16)
        signWithWalletButton.setHeight(to: 50)
        signWithWalletButton.configuration = .filled()
        signWithWalletButton.configuration?.cornerStyle = .capsule
        signWithWalletButton.setTitle("Sign in", for: .normal)
        signWithWalletButton.addTarget(self, action: #selector(signWithWalletButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - signWithWalletButtonPressed function.
    
    @objc
    private func signWithWalletButtonPressed() {
        if UserDefaults.standard.bool(forKey: "reg") {
            let vc = AuthorizationViewController()
            let nc = UINavigationController(rootViewController: vc)
            self.navigationController?.present(nc, animated: true)
        } else {
            let vc = RegistrationViewController()
            let nc = UINavigationController(rootViewController: vc)
            self.navigationController?.present(nc, animated: true)
        }
    }
}
