//
//  OperationsViewController.swift
//  Application
//

import UIKit

class OperationsViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var presentedTokens: [TokenSeries]?

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
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = "Buy"
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
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/list_tokens_series")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(">>>>> api/list_tokens_series: get data error")
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let response = try decoder.decode(TokenSeriesResponse.self, from: data)
                print("===== api/list_tokens_series: tokenSeries =====")
                print(response.tokenSeries)
                
                self.presentedTokens = response.tokenSeries
            } catch {
                print(">>>>> api/list_tokens_series: decoding error")
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
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
        content.secondaryText = DateManager.getStringDate(string: presentedTokens?[indexPath.row].created)
        content.image = UIImage(named: "icon_small.svg")
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
