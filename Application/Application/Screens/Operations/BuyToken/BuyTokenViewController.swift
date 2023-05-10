//
//  BuyTokenViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 12.04.2023.
//

import UIKit
import web3swift
import Web3Core
import Combine
import metamask_ios_sdk

class BuyTokenViewController: UIViewController {
    
    // MARK: - Properties.
    
    var ethereum: Ethereum = MetaMaskSDK.shared.ethereum
    private var cancellables: Set<AnyCancellable> = []
    private let dapp = Dapp(name: "Dub Dapp", url: "https://dubdapp.com")
    
    private let infoLabel = UILabel()
    private let textField = UITextField()
    private let buyButton = UIButton(type: .system)
    let Abi = """
    [
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "startId",
                    "type": "uint256"
                },
                {
                    "internalType": "uint256",
                    "name": "endId",
                    "type": "uint256"
                }
            ],
            "name": "buyToken",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "startId",
                    "type": "uint256"
                },
                {
                    "internalType": "uint256",
                    "name": "endId",
                    "type": "uint256"
                }
            ],
            "name": "expireToken",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "address",
                    "name": "currency",
                    "type": "address"
                },
                {
                    "internalType": "address",
                    "name": "token",
                    "type": "address"
                }
            ],
            "stateMutability": "nonpayable",
            "type": "constructor"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": true,
                    "internalType": "address",
                    "name": "previousOwner",
                    "type": "address"
                },
                {
                    "indexed": true,
                    "internalType": "address",
                    "name": "newOwner",
                    "type": "address"
                }
            ],
            "name": "OwnershipTransferred",
            "type": "event"
        },
        {
            "inputs": [],
            "name": "renounceOwnership",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "address",
                    "name": "newOwner",
                    "type": "address"
                }
            ],
            "name": "transferOwnership",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "address",
                    "name": "",
                    "type": "address"
                },
                {
                    "internalType": "address",
                    "name": "",
                    "type": "address"
                },
                {
                    "internalType": "uint256",
                    "name": "",
                    "type": "uint256"
                },
                {
                    "internalType": "bytes",
                    "name": "",
                    "type": "bytes"
                }
            ],
            "name": "onERC721Received",
            "outputs": [
                {
                    "internalType": "bytes4",
                    "name": "",
                    "type": "bytes4"
                }
            ],
            "stateMutability": "pure",
            "type": "function"
        },
        {
            "inputs": [],
            "name": "owner",
            "outputs": [
                {
                    "internalType": "address",
                    "name": "",
                    "type": "address"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        }
    ]


    """
    
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
        ethereum.connect(dapp)?.sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                print("Connection error: \(error.localizedDescription)")
            default: break
            }
        }, receiveValue: { result in
            print("Connection result: \(result)")
        }).store(in: &cancellables)
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
        let walletAddress = EthereumAddress(UserDefaults.standard.string(forKey: "address")!)
        let contractAddress = EthereumAddress("0xA6FB215880433199E21363f1d6022A0d2b7e125b")
        let endpoint = "https://sepolia.infura.io/v3/00c0dc2e240c40c392f4c2522526babd"
        let contractMethod = "buyToken"
        let parameters = [1, 1]
        let extraData = Data()
        print("1")
//        let web3 = await web3swift.Web3(provider: Web3HttpProvider(URL(string: endpoint)!, network: .Custom(networkID: 11155111))!)
        do {
            print("2")
            Task {
//                let web3 = try await web3swift.Web3(provider: InfuraProvider(net: .Custom(networkID: 11155111)))
                let web3 = try await web3swift.Web3(provider: Web3HttpProvider(url: URL(string: endpoint)!, network: .Custom(networkID: 11155111)))
                let keystore = try! EthereumKeystoreV3(password: "")
                let keystoreManager = KeystoreManager([keystore!])
                web3.addKeystoreManager(keystoreManager)
                let address = keystoreManager.addresses![0]
                
                print("3")
                let contract = web3.contract(Abi, at: contractAddress, abiVersion: 2)!
                print(contract.contract.allEvents)
                print("4")
                let tx = contract.createWriteOperation(contractMethod, parameters: parameters, extraData: extraData)!
                print("5")
                tx.transaction.from = walletAddress
                
                let parameters: [String: String] = [
                    "value": "0",
                    "gas": "47288",
                    "maxFeePerGas": "1000000007",
                    "maxPriorityFeePerGas": "999999993",
                    "chainId": "11155111",
                    "from": "0xE6C9789Be58FC30C5650c6c7Cf1c2aFFA480b856",
                    "nonce": "0",
                    "to": "0xF6449353Db59383a5eC4C7A752E7Dcf237692422",
                    "data": "0x39509351000000000000000000000000a6fb215880433199e21363f1d6022a0d2b7e125b0000000000000000000000000000000000000000000000000000000000000064"
                  ]
                
                let transactionRequest = EthereumRequest(
                    method: .ethSendTransaction,
                    params: [parameters] // eth_sendTransaction rpc call expects an array parameters object
                )

                ethereum.request(transactionRequest)?.sink(receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        print("Transaction error: \(error.localizedDescription)")
                    default: break
                    }
                }, receiveValue: { value in
                    print("Transaction result: \(value)")
                }).store(in: &cancellables)

                // Make a transaction request
                ethereum.request(transactionRequest)?.sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                    default: break
                    }
                }, receiveValue: { result in
                    print(result)
                })
                .store(in: &cancellables)
                
                print("6")
                let call = try await tx.callContractMethod()
                print("7")
                
            }
        } catch {
            print("error")
        }
        print("8")
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
                        Expiration date: \(model?.burnDate ?? "-")
                        Income: \(model?.profit ?? 0)
                        Other information: \(model?.metadata ?? "-")
                        """
    }
}
