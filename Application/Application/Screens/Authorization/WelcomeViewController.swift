//
//  WelcomeScreenViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 18.04.2023.
//

import UIKit
import Glaip

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let signWithWalletButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    private var glaip = Glaip(
         title: "Glaip Demo App",
         description: "Demo app to demonstrate Web3 login",
         supportedWallets: [.MetaMask])
    
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
        signWithWalletButton.setTitle("Sign in with wallet", for: .normal)
        signWithWalletButton.addTarget(self, action: #selector(signWithWalletButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - signWithWalletButtonPressed function.
    
    @objc
    private func signWithWalletButtonPressed() {
        glaip.loginUser(type: .MetaMask) { result in
            switch result {
            case .success(let user):
                print(user.wallet.address)
                UserDefaults.standard.set(user.wallet.address, forKey: "address")
                UserDefaults.standard.set(1000, forKey: "account")
                DispatchQueue.main.async {
//                    let registerViewController = RegistrationViewController()
//                    let vc = UINavigationController(rootViewController: registerViewController)
                    let authorizationViewController = AuthorizationViewController()
                    let vc = UINavigationController(rootViewController: authorizationViewController)
                    self.navigationController?.present(vc, animated: true)
                }
            case .failure(let error):
                print(error)
          }
        }
    }
}
