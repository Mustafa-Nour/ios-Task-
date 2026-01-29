//
//  SecondScreen.swift
//  iOS Task
//
//  Created by Mustafa Nour on 29/01/2026.
//

import Foundation
import UIKit
class PostCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .secondaryLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class secondScreenApi: UIViewController {
    let tableView = UITableView()
    let viewModel = PostViewModel()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupNotifications()
        viewModel.fetchPosts()
    }
}

extension secondScreenApi {
    func setupUI() {
        navigationItem.title = "posts_title".localized
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func refreshData() {
        viewModel.fetchPosts()
    }
    
    func setupViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.refreshControl.endRefreshing()
            self?.showAlert(title: "Error", message: errorMessage)
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(internetLost), name: .internetConnectionLost, object: nil)
    }
    
    @objc func internetLost() {
        showAlert(title: "Connection Lost", message: "You are now in offline mode. Loading cached data if available.")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension secondScreenApi: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = viewModel.posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
}
