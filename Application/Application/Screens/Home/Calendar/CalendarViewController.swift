//
//  CalendarViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 03.04.2023.
//

import UIKit

class CalendarViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var userTokens: [TokenPackModel]?
    
    // MARK: - viewDidLoad function.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
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
        title = "Calendar"
        fetchUserTokens()
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
    
    // MARK: - fetchUserTokens function.
    
    private func fetchUserTokens() {
        userTokens = [
            TokenPackModel(id: 1, user: UserModel(id: 1, role: "common", address: "-", balance: 0), token: TokenModel(id: 1, name: "BTOT", amount: 500, price: 20, emissionDate: "01.05.2023", burnDate: "11.05.2023", profit: 22, metadata: "-"), amount: 12)]
    }
}

// MARK: - Delegate extension.

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - DataSource extension.

extension CalendarViewController : UITableViewDataSource {
    
    // MARK: - Setup number of sections.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Setup cells number.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTokens?.count ?? 0
    }
    
    // MARK: - Setup cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = userTokens?[indexPath.row].token?.burnDate
        content.secondaryText = userTokens?[indexPath.row].token?.name
        cell.contentConfiguration = content
        return cell
    }
}
