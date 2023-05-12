//
//  CalendarViewController.swift
//  Application
//

import UIKit

class CalendarViewController: UIViewController {
    
    // MARK: - Properties.
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var userPacks: [Pack]?
    private var presentedTokens: [TokenSeries]?
    private var tokens: [TokenModel] = []
    
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
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/user_packs")!)
        request.addValue("Token \(String(describing: UserDefaults.standard.string(forKey: "address")!))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(">>>>> api/user_packs: get data error")
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(PacksResponse.self, from: data)
                print("===== api/user_packs: packs =====")
                print(response.status)
                print(response.packs)
                
                self.userPacks = response.packs
                self.fetchPresentedTokens()
            } catch {
                print(">>>>> api/user_packs: decoding error: \(error)")
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
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
                self.tokens.removeAll()
                for tok1 in self.userPacks ?? [] {
                    for tok2 in self.presentedTokens ?? [] {
                        if tok1.tokenSeries == tok2.id {
                            self.tokens.append(TokenModel(id: tok2.id, name: tok2.name, amount: tok1.numberOfTokens, expirationDatetime: tok2.expirationDatetime))
                            break
                        }
                    }
                }
            } catch {
                print(">>>>> api/list_tokens_series: decoding error")
            }
        }
        task.resume()
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
        return tokens.count
    }
    
    // MARK: - Setup cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = DateManager.getStringDate(string: tokens[indexPath.row].expirationDatetime)
        content.secondaryText = "\(tokens[indexPath.row].name) \(tokens[indexPath.row].id)"
        cell.contentConfiguration = content
        return cell
    }
}
