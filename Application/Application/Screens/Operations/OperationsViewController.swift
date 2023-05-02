//
//  OperationsViewController.swift
//  Application
//
//  Created by Максим Кузнецов on 01.03.2023.
//

import UIKit

class OperationsViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var presentedTokens: [TokenModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
        setupNavBar()
        fetchPresentedTokens()
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = "Transactions"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
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
    
    // MARK: - Setup Views.
    
    private func setupViews() {
        setupTableView()
    }
    
    // MARK: - TableView setup.
        
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tokenCell")
        setupTableViewAppearance()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsMultipleSelection = false
        setupTableViewPosition()
    }
    
    // MARK: - TableView setup.
    
    private func setupTableViewAppearance() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = true
    }
    
    private func setupTableViewPosition() {
        view.addSubview(tableView)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
    }
    
    // MARK: - fetchPresentedTokens function.
    
    private func fetchPresentedTokens() {
        presentedTokens = [
            TokenModel(id: 1, name: "BTOT", amount: 500, price: 20, emissionDate: "01.05.2023", burnDate: "11.05.2023", profit: 22, metadata: "-"),
            TokenModel(id: 1, name: "BTOT", amount: 100, price: 50, emissionDate: "02.05.2023", burnDate: "11.05.2023", profit: 25, metadata: "-"),
            TokenModel(id: 1, name: "BTOT", amount: 700, price: 17, emissionDate: "03.05.2023", burnDate: "11.05.2023", profit: 18, metadata: "-")]
    }
}

// MARK: - Delegate extension.

extension OperationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buyTokenViewController = BuyTokenViewController()
        buyTokenViewController.configure(model: presentedTokens?[indexPath.row])
        navigationController?.pushViewController(buyTokenViewController, animated: true)
    }
}


// MARK: - DataSource extension.

extension OperationsViewController: UITableViewDataSource {
    
    // MARK: - Setup number of sections.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Cells number.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentedTokens?.count ?? 0
    }
    
    // MARK: - Setup cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tokenCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = presentedTokens?[indexPath.row].name
        content.secondaryText = presentedTokens?[indexPath.row].emissionDate
        content.image = UIImage(named: "icon_small.svg")
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
