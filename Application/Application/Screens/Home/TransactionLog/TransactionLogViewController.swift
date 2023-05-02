//
//  TransactionLogViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 03.03.2023.
//

import UIKit

class TransactionLogViewController: UIViewController {
    
    // MARK: - Properties.
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var operations: [OperationModel]?
    
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
        operations = [
            OperationModel(id: 1, user: UserModel(id: 1, role: "common", address: "-", balance: 0), type: "transaction", description: "+100 ₽", date: "01.05.2023"),
            OperationModel(id: 1, user: UserModel(id: 1, role: "common", address: "-", balance: 0), type: "transaction", description: "+30 BTOT", date: "03.05.2023"),
            OperationModel(id: 1, user: UserModel(id: 1, role: "common", address: "-", balance: 0), type: "transaction", description: "+12 BTOT", date: "07.05.2023"),]
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
        content.text = operations?[indexPath.row].description
        content.secondaryText = operations?[indexPath.row].date
        cell.contentConfiguration = content
        return cell
    }
}

