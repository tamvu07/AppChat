//
//  ViewController.swift
//  AppChat
//
//  Created by Vu Minh Tam on 7/19/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

class ConversationsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private var conversations = [Conversation]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        table.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()

    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        setupTableView()
        fetchConversations()
//        startListeningForConversations()
    }
    
//    private func startListeningForConversations() {
//        guard  let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//
//        print("Starting conversation fetch...")
//
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//
//        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
//            switch result {
//            case .success(let conversations):
//                print("successfully got conversation models")
//                guard !conversations.isEmpty else {
//                    return
//                }
//
//                self?.conversations = conversations
//
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//
//            case .failure(let error):
//                print("Failed to \(error)")
//            }
//        })
//    }
    
    @objc private func didTapComposeButton() {
        let vc = NewConversationViewController()
//        vc.completion = { [weak self] result in
//            self?.createNewConversation(result: result)
//        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
//    private func createNewConversation(result: [String: String]) {
//        guard let name = result["name"],
//              let email = result["email"] else {
//            return
//        }
//        let vc = ChatsViewController(with: email, id: nil)
//        vc.isNewConversation = true
//        vc.title = name
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }

    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func fetchConversations() {
        tableView.isHidden = false
    }

}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return conversations.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = conversations[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
//        cell.configure(with: model)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "abc"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let model = conversations[indexPath.row]
        
//        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        let vc = ChatViewController()
//        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
