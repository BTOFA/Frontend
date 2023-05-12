//
//  PutMoneyViewController.swift
//  Application
//

import UIKit

class PutMoneyViewController: UIViewController {
    
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
        title = "Put money"
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

    // MARK: - setupViews function.
    
    private func setupViews() {
        setupTextField()
        setupSubmitButton()
    }
    
    // MARK: - setupTextField function.
    
    private func setupTextField() {
        view.addSubview(textField)
        textField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        textField.pinLeft(to: view.leadingAnchor, 16)
        textField.pinRight(to: view.trailingAnchor, 16)
        textField.setHeight(to: 50)
        let paddingView = UIView()
        let textLabel = UILabel()
        textLabel.setWidth(to: 90)
        textLabel.setHeight(to: 40)
        paddingView.addSubview(textLabel)
        textLabel.pinTop(to: paddingView, 5)
        textLabel.pinBottom(to: paddingView, 5)
        textLabel.pinLeft(to: paddingView, 10)
        textLabel.pinRight(to: paddingView, 5)
        textLabel.text = "Amount ₽:"
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
        textField.isUserInteractionEnabled = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    
    // MARK: - setupSubmitButton function.
    
    private func setupSubmitButton() {
        view.addSubview(submitButton)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.configuration = .filled()
        submitButton.configuration?.cornerStyle = .medium
        submitButton.setHeight(to: 50)
        submitButton.pinTop(to: textField.bottomAnchor, 10)
        submitButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 16)
        submitButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 16)
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        submitButton.isEnabled = false
        submitButton.isUserInteractionEnabled = true
    }
    
    // MARK: - submitButtonPressed function.
    
    @objc
    private func submitButtonPressed() {
        submitButton.configuration?.showsActivityIndicator = true
        submitButton.isUserInteractionEnabled = false
        textField.isUserInteractionEnabled = false
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/add_balance")!)
        let params: [String: Any] = ["wallet": "0x49b0E787e04DF1Adf6c3468C1FA6EC1d0C1A2b63",
                                     "plus": Int(textField.text!) ?? 0]
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
                print("===== api/add_balance response =====")
                print(responseJSON)
                if responseJSON["status"] as! String != "ok" {
                    let alert = UIAlertController(title: "Error", message: "Failed to put money", preferredStyle: UIAlertController.Style.alert)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to put money", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true, completion: nil)
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        task.resume()
    }
    
    // MARK: - textFieldDidChange function.
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        if textField.text!.count > 0 && textField.text!.count < 10 {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
}
