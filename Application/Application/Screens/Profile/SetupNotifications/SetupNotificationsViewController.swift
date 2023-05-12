//
//  SetupNotificationsViewController.swift
//  Application
//

import UIKit
import UserNotifications

class SetupNotificationsViewController: UIViewController {
    
    // MARK: - Properties.
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let switchView = UISwitch(frame: .zero)
    private var userPacks: [Pack]?
    private var presentedTokens: [TokenSeries]?
    private var tokens: [TokenModel] = []
    
    // MARK: - viewDidLoad function.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupViews()
        checkForPermission()
    }
    
    // MARK: - viewWillAppear function.

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
        title = "Setup notifications"
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
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
        setupTableView()
    }
    
    // MARK: - TableView setup.
        
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        setupTableViewAppearance()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsMultipleSelection = false
        tableView.isUserInteractionEnabled = true
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
    
    // MARK: - Notifications setup.
    
    private func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                if UserDefaults.standard.bool(forKey: "expirationNotification") {
                    for tok in self.tokens {
                        let date = DateManager.getDateFromString(string: tok.expirationDatetime)
                        let components = date.get(.year, .month, .day)
                        let currentDate = Date()
                        let currentComponents = currentDate.get(.year, .month, .day)
                        if components.year == currentComponents.year &&
                            components.month == currentComponents.month &&
                            components.day == currentComponents.day {
                            let calendar = Calendar.current
                            let newDate = calendar.date(byAdding: .minute, value: 1, to: currentDate)!
                            self.dispatchNotification(date: newDate, tokenName: tok.name)
                        } else {
                            self.dispatchNotification(date: date, tokenName: tok.name)
                        }
                    }
                }
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                    if UserDefaults.standard.bool(forKey: "expirationNotification") {
                        if self.switchView.isOn {
                            for tok in self.tokens {
                                let date = DateManager.getDateFromString(string: tok.expirationDatetime)
                                let components = date.get(.year, .month, .day)
                                let currentDate = Date()
                                let currentComponents = currentDate.get(.year, .month, .day)
                                if components.year == currentComponents.year &&
                                    components.month == currentComponents.month &&
                                    components.day == currentComponents.day {
                                    let calendar = Calendar.current
                                    let newDate = calendar.date(byAdding: .minute, value: 1, to: currentDate)!
                                    self.dispatchNotification(date: newDate, tokenName: tok.name)
                                } else {
                                    self.dispatchNotification(date: date, tokenName: tok.name)
                                }
                            }
                        }
                    }
                }
            default:
                return
            }
        }
    }
    
    private func dispatchNotification(date: Date, tokenName: String) {
        let identifier = "income-notification"
        let title = "Profit!"
        let body = "The token \(tokenName) burned down and you made a profit"
        let components = date.get(.year, .month, .day, .hour, .minute)
        let isDaily = false
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
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

extension SetupNotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - DataSource extension.

extension SetupNotificationsViewController : UITableViewDataSource {
    
    // MARK: - Setup number of sections.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Setup cells number.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Setup cell height.
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - Setup cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = "Token expiration"
                cell.contentConfiguration = content
                switchView.setOn(UserDefaults.standard.bool(forKey: "expirationNotification"), animated: true)
                switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
                cell.accessoryView = switchView
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    // MARK: - switchValueChanged function.
    
    @objc
    private func switchValueChanged(switchView: UISwitch) {
        UserDefaults.standard.set(switchView.isOn, forKey: "expirationNotification")
        if switchView.isOn {
            for tok in tokens {
                let date = DateManager.getDateFromString(string: tok.expirationDatetime)
                let components = date.get(.year, .month, .day)
                let currentDate = Date()
                let currentComponents = currentDate.get(.year, .month, .day)
                if components.year == currentComponents.year &&
                    components.month == currentComponents.month &&
                    components.day == currentComponents.day {
                    let calendar = Calendar.current
                    let newDate = calendar.date(byAdding: .minute, value: 1, to: currentDate)!
                    dispatchNotification(date: newDate, tokenName: tok.name)
                } else {
                    dispatchNotification(date: date, tokenName: tok.name)
                }
            }
        } else {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }
}
