//
//  ViewController.swift
//  Application
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties.
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var balance: String?

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
        setupNavBar()
        tableView.reloadData()
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/user_info")!)
        if let str = UserDefaults.standard.string(forKey: "address") {
            request.addValue("Token \(String(describing: str))", forHTTPHeaderField: "Authorization")
        }
        print("===== UserDefaults token =====")
        print(String(describing: UserDefaults.standard.string(forKey: "address") ?? "no info"))
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("===== api/user_info response =====")
                print(responseJSON)
                if let balanceData = responseJSON["balance"] {
                    self.balance = String(describing: balanceData)
                } else {
                    print(">>>>> api/user_info error while getting balance")
                }
                if let walletData = responseJSON["wallet"] {
                    UserDefaults.standard.setValue(String(describing: walletData), forKey: "wallet")
                } else {
                    print(">>>>> api/user_info error while getting wallet address")
                }
                if let trueWalletData = responseJSON["true_wallet"] {
                    UserDefaults.standard.setValue(String(describing: trueWalletData), forKey: "true_wallet")
                } else {
                    print(">>>>> api/user_info error while getting true_wallet")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
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
    
    // MARK: - setupNavBar function.
    
    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Setup Views.
    
    private func setupViews() {
        setupTableView()
    }
    
    // MARK: - TableView setup.
        
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "widgetCell")
        setupTableViewAppearance()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsMultipleSelection = false
        setupTableViewPosition()
    }
    
    private func setupTableViewAppearance() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupTableViewPosition() {
        view.addSubview(tableView)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
    }
}

// MARK: - Delegate extension.

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let transactionLogViewController = TransactionLogViewController()
                navigationController?.pushViewController(transactionLogViewController, animated: true)
            } else if indexPath.row == 2 {
                let putMoneyViewController = PutMoneyViewController()
                navigationController?.pushViewController(putMoneyViewController, animated: true)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let myTokensViewController = MyTokensViewController()
                navigationController?.pushViewController(myTokensViewController, animated: true)
            } else if indexPath.row == 1 {
                let calendarViewController = CalendarViewController()
                navigationController?.pushViewController(calendarViewController, animated: true)
            }
        }
    }
}

// MARK: - DataSource extension.

extension HomeViewController : UITableViewDataSource {
    
    // MARK: - Setup number of sections.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: - Setup cells number.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    // MARK: - Setup cell height.
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 80
        }
        return 50
    }
    
    // MARK: - Setup cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.image = UIImage(systemName: "briefcase.circle.fill")
                content.text = "Account"
                content.secondaryText = (balance ?? "no info") + " BTOC"
                content.textProperties.font = .boldSystemFont(ofSize: 18)
                content.secondaryTextProperties.font = .systemFont(ofSize: 18)
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.contentConfiguration = content
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCell", for: indexPath)
                customizeCell(cell: cell, text: "Transactions history", image: UIImage(systemName: "clock.fill")!)
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCell", for: indexPath)
                customizeCell(cell: cell, text: "Put money", image: UIImage(systemName: "dollarsign.circle.fill")!)
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCell", for: indexPath)
                customizeCell(cell: cell, text: "My tokens", image: UIImage(systemName: "t.circle.fill")!)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCell", for: indexPath)
                customizeCell(cell: cell, text: "Calendar", image: UIImage(systemName: "calendar.circle.fill")!)
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    private func customizeCell(cell: UITableViewCell, text: String, image: UIImage) {
        var content = cell.defaultContentConfiguration()
        content.text = text
        content.image = image
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
    }
}
