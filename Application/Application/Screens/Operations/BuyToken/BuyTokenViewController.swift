//
//  BuyTokenViewController.swift
//  Application
//

import UIKit

class BuyTokenViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let infoLabel = UILabel()
    private let textField = UITextField()
    private let buyButton = UIButton(type: .system)
    private var tokenModel: TokenSeries?
    
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
        setupInfoLabel()
        setupTextField()
        setupBuyButton()
    }
    
    // MARK: - setupInfoLabel function.
    
    private func setupInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        infoLabel.pinLeft(to: view, 16)
        infoLabel.pinRight(to: view, 16)
        infoLabel.textAlignment = .left
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.numberOfLines = .zero
        infoLabel.textColor = .label
        infoLabel.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    // MARK: - setupTextField function.
    
    private func setupTextField() {
        view.addSubview(textField)
        textField.pinTop(to: infoLabel.bottomAnchor, 16)
        textField.pinLeft(to: view.leadingAnchor, 16)
        textField.pinRight(to: view.trailingAnchor, 16)
        textField.setHeight(to: 50)
        let paddingView = UIView()
        let textLabel = UILabel()
        textLabel.setWidth(to: 80)
        textLabel.setHeight(to: 40)
        paddingView.addSubview(textLabel)
        textLabel.pinTop(to: paddingView, 5)
        textLabel.pinBottom(to: paddingView, 5)
        textLabel.pinLeft(to: paddingView, 10)
        textLabel.pinRight(to: paddingView, 5)
        textLabel.text = "Amount:"
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
    
    // MARK: - setupBuyButton function.
    
    private func setupBuyButton() {
        view.addSubview(buyButton)
        buyButton.pinTop(to: textField.bottomAnchor, 10)
        buyButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 16)
        buyButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 16)
        buyButton.setHeight(to: 50)
        buyButton.setTitle("Submit", for: .normal)
        buyButton.configuration = .filled()
        buyButton.configuration?.cornerStyle = .medium
        buyButton.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
        buyButton.isEnabled = false
        buyButton.isUserInteractionEnabled = true
    }
    
    // MARK: - buyButtonPressed function.
    
    @objc
    private func buyButtonPressed() {
        textField.isUserInteractionEnabled = false
        buyButton.isUserInteractionEnabled = false
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/buy_token")!)
        print(Int(textField.text!)!)
        print(Int(exactly: tokenModel!.id)!)
        let params: [String: Any] = ["id": Int(exactly: tokenModel!.id)!,
                                     "number_of_tokens": Int(textField.text!)!]
        let body = try? JSONSerialization.data(withJSONObject: params)
        
        print(params)
        request.addValue("Token \(String(describing: UserDefaults.standard.string(forKey: "address")!))", forHTTPHeaderField: "Authorization")
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
                print("===== api/buy_token response =====")
                print(responseJSON)
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
            buyButton.isEnabled = true
        } else {
            buyButton.isEnabled = false
        }
    }
    
    // MARK: - configure function.
    
    public func configure(model: TokenSeries?) {
        tokenModel = model
        title = model?.name
        infoLabel.text = """
                        Amount: \(model?.numberOfTokens ?? 0)
                        Price: \(model?.cost ?? 0)
                        Emission date: \(DateManager.getStringDate(string: model?.created ?? "2023-05-12T11:01:00.854710Z"))
                        Expiration date: \(DateManager.getStringDate(string: model?.expirationDatetime ?? "2023-05-12T11:01:00.854710Z"))
                        Income: \(model?.dividends ?? 0)
                        Other information: \(model?.metainfo ?? "-")
                        """
    }
}
