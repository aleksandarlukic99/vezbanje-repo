//
//  NotificationViewController.swift
//  Instagram
//
//  Created by aleksandar on 15.12.21..
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

class NotificationViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        
        return spinner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        //spinner.startAnimating()
        view.addSubview(spinner)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    //MARK: - Methods
    
    private func addNoNotificationsView() {
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width / 2,
            height: view.width / 4)
        noNotificationsView.center = view.center
    }
    
    private func fetchNotifications() {
        for x in 0...100 {
            let user = User(username: "Joe",
                            name: (first: "", last: ""),
                            bio: "",
                            birthDate: Date(),
                            profilePicture: URL(string: "https://www.google.com")!,
                            gender: .male,
                            counts: UserCounts(followers: 1, following: 1, posts: 1),
                            joinDate: Date())
            let post = UserPost(
                identifier: "",
                postType: .photo,
                thumbnailImage: URL(string: "https://www.google.com")!,
                postURL: URL(string: "https://www.google.com")!,
                caption: nil,
                likeCount: [],
                comments: [],
                createdDate: Date(),
                taggedUsers: [],
                owner: user)
            let model = UserNotification(
                type: x % 2 == 0 ? .like(post: post) : .follow(state: .notFollowing),
                text: "Hello",
                user: user)
            models.append(model)
        }
    }
    
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier, for: indexPath) as! NotificationFollowEventTableViewCell
            cell.delegate = self
            //cell.configure(with: model)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

//MARK: - Delegates

extension NotificationViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Should never get called")
        }
    }
}

extension NotificationViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapUnfollowButton(model: UserNotification) {
        print("Tapped button")
        //perform database update
    }
}
