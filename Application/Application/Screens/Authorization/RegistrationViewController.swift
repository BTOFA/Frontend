//
//  RegistrationViewController.swift
//  Application
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let firstTextField = UITextField()
    private let secondTextField = UITextField()
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
            firstTextField.backgroundColor = .systemBackground
            secondTextField.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .systemBackground
            firstTextField.backgroundColor = .secondarySystemBackground
            secondTextField.backgroundColor = .secondarySystemBackground
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
            firstTextField.backgroundColor = .systemBackground
            secondTextField.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .systemBackground
            firstTextField.backgroundColor = .secondarySystemBackground
            secondTextField.backgroundColor = .secondarySystemBackground
        }
    }
    
    // MARK: - setupNavBar function.
    
    private func setupNavBar() {
        title = "Create a password"
    }
    
    // MARK: - Setup Views.
    
    private func setupViews() {
        setupFirstTextField()
        setupSecondTextField()
        setupSubmitButton()
    }
    
    // MARK: - setupFirstTextField function.
    
    private func setupFirstTextField() {
        view.addSubview(firstTextField)
        firstTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        firstTextField.pinLeft(to: view.leadingAnchor, 16)
        firstTextField.pinRight(to: view.trailingAnchor, 16)
        firstTextField.setHeight(to: 50)
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
        firstTextField.leftView = paddingView
        firstTextField.leftViewMode = .always
        firstTextField.backgroundColor = .systemBackground
        firstTextField.layer.cornerRadius = 10
        firstTextField.keyboardType = .asciiCapableNumberPad
        firstTextField.returnKeyType = UIReturnKeyType.done
        firstTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        firstTextField.placeholder = "Create password"
        firstTextField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    
    // MARK: - setupSecondTextField function.
    
    private func setupSecondTextField() {
        view.addSubview(secondTextField)
        secondTextField.pinTop(to: firstTextField.bottomAnchor, 10)
        secondTextField.pinLeft(to: view.leadingAnchor, 16)
        secondTextField.pinRight(to: view.trailingAnchor, 16)
        secondTextField.setHeight(to: 50)
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
        secondTextField.leftView = paddingView
        secondTextField.leftViewMode = .always
        secondTextField.backgroundColor = .systemBackground
        secondTextField.layer.cornerRadius = 10
        secondTextField.keyboardType = .asciiCapableNumberPad
        secondTextField.returnKeyType = UIReturnKeyType.done
        secondTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        secondTextField.placeholder = "Type password again"
        secondTextField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    
    // MARK: - setupSubmitButton function.
    
    private func setupSubmitButton() {
        view.addSubview(submitButton)
        submitButton.setTitle("Register", for: .normal)
        submitButton.configuration = .filled()
        submitButton.configuration?.cornerStyle = .medium
        submitButton.setHeight(to: 50)
        submitButton.pinTop(to: secondTextField.bottomAnchor, 10)
        submitButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 16)
        submitButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 16)
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        submitButton.isEnabled = false
    }
    
    // MARK: - textFieldDidChange function.
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        if firstTextField.text!.count > 0 && firstTextField.text!.count < 10 &&
            secondTextField.text!.count > 0 && secondTextField.text!.count < 10 &&
            firstTextField.text! == secondTextField.text! {
            submitButton.isEnabled = true
            firstTextField.tintColor = .tintColor
        } else {
            submitButton.isEnabled = false
        }
    }
    
    // MARK: - submitButtonPressed function.
    
    @objc
    private func submitButtonPressed() {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/register_user")!)
        let params: [String: Any] = ["wallet": "0x49b0E787e04DF1Adf6c3468C1FA6EC1d0C1A2b63",
                                    "password": firstTextField.text!]
        let body = try? JSONSerialization.data(withJSONObject: params)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("===== api/register_user response =====")
                print(responseJSON)
                UserDefaults.standard.setValue(String(describing: responseJSON["auth_token"]!), forKey: "address")
                UserDefaults.standard.setValue(true, forKey: "reg")
            }
            
            DispatchQueue.main.async {
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
        task.resume()
    }
}
