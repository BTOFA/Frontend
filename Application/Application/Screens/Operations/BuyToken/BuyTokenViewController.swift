//
//  BuyTokenViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 12.04.2023.
//

import UIKit

class BuyTokenViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let infoLabel = UILabel()
    private let textField = UITextField()
    private let buyButton = UIButton(type: .system)
    
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
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    
    // MARK: - setupBuyButton function.
    
    private func setupBuyButton() {
        view.addSubview(buyButton)
        buyButton.pinTop(to: textField.bottomAnchor, 10)
        buyButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 16)
        buyButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 16)
        buyButton.setHeight(to: 50)
        buyButton.setTitle("Buy", for: .normal)
        buyButton.configuration = .filled()
        buyButton.configuration?.cornerStyle = .medium
        buyButton.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
        buyButton.isEnabled = false
    }
    
    // MARK: - buyButtonPressed function.
    
    @objc
    private func buyButtonPressed() {
        navigationController?.popViewController(animated: true)
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
    
    public func configure(model: TokenModel?) {
        title = model?.name
        infoLabel.text = """
                        Amount: \(model?.amount ?? 0)
                        Price: \(model?.price ?? 0)
                        Emission date: \(model?.emissionDate ?? "-")
                        Burn date: \(model?.burnDate ?? "-")
                        Profit: \(model?.profit ?? 0)
                        Other information: \(model?.metadata ?? "-")
                        """
    }
}
