//
//  AuthorizationViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 06.05.2023.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let textField = UITextField()
    private let submitButton = UIButton(type: .system)
    
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
            textField.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .systemBackground
            textField.backgroundColor = .secondarySystemBackground
        }
        setupNavBar()
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
            textField.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .systemBackground
            textField.backgroundColor = .secondarySystemBackground
        }
    }
    
    // MARK: - setupNavBar function.
    
    private func setupNavBar() {
        title = "Enter password"
    }
    
    // MARK: - Setup Views.
    
    private func setupViews() {
        setupTextField()
        setupSubmitButton()
    }
    
    // MARK: - setupTextField function.
    
    private func setupTextField() {
        view.addSubview(textField)
        textField.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        textField.pinLeft(to: view.leadingAnchor, 16)
        textField.pinRight(to: view.trailingAnchor, 16)
        textField.setHeight(to: 50)
        let paddingView = UIView()
        let textLabel = UILabel()
        textLabel.setWidth(to: 100)
        textLabel.setHeight(to: 40)
        paddingView.addSubview(textLabel)
        textLabel.pinTop(to: paddingView, 5)
        textLabel.pinBottom(to: paddingView, 5)
        textLabel.pinLeft(to: paddingView, 10)
        textLabel.pinRight(to: paddingView, 5)
        textLabel.text = "Password:"
        textLabel.textAlignment = .left
        textLabel.textColor = .label
        textLabel.font = .systemFont(ofSize: 18, weight: .medium)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 10
        textField.keyboardType = .asciiCapableNumberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "Enter password"
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    
    // MARK: - setupSubmitButton function.
    
    private func setupSubmitButton() {
        view.addSubview(submitButton)
        submitButton.setTitle("Log in", for: .normal)
        submitButton.configuration = .filled()
        submitButton.configuration?.cornerStyle = .medium
        submitButton.setHeight(to: 50)
        submitButton.pinTop(to: textField.bottomAnchor, 10)
        submitButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 16)
        submitButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 16)
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        submitButton.isEnabled = false
    }
    
    // MARK: - textFieldDidChange function.
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        if textField.text!.count > 0 && textField.text!.count < 10 {
            submitButton.isEnabled = true
            textField.tintColor = .tintColor
        } else {
            submitButton.isEnabled = false
        }
    }
    
    // MARK: - submitButtonPressed function.
    
    @objc
    private func submitButtonPressed() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = true
        tabBarController.viewControllers = [
            SceneDelegate.createHomeViewController(),
            SceneDelegate.createOperationsViewController(),
            SceneDelegate.createProfileViewController()
        ]
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(
        UINavigationController(rootViewController: tabBarController))
    }
}