//
//  TransactionLogViewController.swift
//  Application
//

import UIKit

class TransactionLogViewController: UIViewController {
    
    // MARK: - Properties.
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var operations: [History]?
    
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
        title = "Transactions history"
        fetchOperations()
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
        setupTableView()
    }
    
    // MARK: - TableView setup.
        
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dateCell")
        setupTableViewAppearance()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
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
    
    // MARK: - fetchOperations function.
    
    private func fetchOperations() {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/user_history")!)
        request.addValue("Token \(String(describing: UserDefaults.standard.string(forKey: "address")!))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(">>>>> api/user_history: get data error")
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let response = try decoder.decode(UserHistoryResponse.self, from: data)
                print("===== api/user_history: history =====")
                print(response.history)
                
                self.operations = response.history
            } catch {
                print(">>>>> api/user_history: decoding error")
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
}

// MARK: - Delegate extension.

extension TransactionLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - DataSource extension.

extension TransactionLogViewController : UITableViewDataSource {
    
    // MARK: - Setup number of sections.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Setup cells number.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations?.count ?? 0
    }
    
    // MARK: - Setup cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        if operations?[indexPath.row].opType == "RE" {
            content.text = "+\(String(describing: operations![indexPath.row].desc)) BTOC"
        } else if operations?[indexPath.row].opType == "PU" {
            content.text = "+\(String(describing: operations![indexPath.row].desc)) BTOT"
        } else {
            content.text = operations?[indexPath.row].desc
        }
        content.secondaryText = DateManager.getStringDate(string: operations?[indexPath.row].performed)
        cell.contentConfiguration = content
        return cell
    }
}
