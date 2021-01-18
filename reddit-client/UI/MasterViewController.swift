//
//  MasterViewController.swift
//  reddit-client
//
//  Created by Francisco Conelli on 14/01/2021.
//

import UIKit

protocol PostSelectionDelegate {
    func postSelected(_ newPost: FeedItem)
}

class MasterViewController: UITableViewController {
    
    var feedItemsList:[FeedItem] = []
    var imageLoader = ImageLoader()
    var delegate: PostSelectionDelegate?
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        
        // fire posts load...
        indicator.startAnimating()
        fetchRedditPosts()
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
        
        self.tableView.register(UINib(nibName: "FeedItemCell", bundle: nil), forCellReuseIdentifier: "FeedItemCell")
        
        // Add Refresh Control to Table View
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.gray
        
        // Configure Refresh Control
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.tableFooterView = UIView()
        
        // loader
        indicator.color = UIColor.systemOrange
        indicator.center = tableView.center
        navigationController?.viewControllers.first?.view.addSubview(indicator)
    }
    
    // MARK: - fetch data
    private func fetchRedditPosts() {
        
        feedsProvider?.fetch() { result in
            switch result {
            case let .success(list):
                self.feedItemsList = list.filter{ !(feedsProvider?.isPostDismissed($0) ?? false) }
            case .failure:
                break
            }
            DispatchQueue.main.async() {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.indicator.stopAnimating()
            }
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.refreshControl?.beginRefreshing()
        fetchRedditPosts()
    }

    @IBAction func dismissAllButtonAction(_ sender: Any) {
        let msg = "Are you sure you want to dismiss ALL posts?"
        let alert = UIAlertController(title: "Dismiss ALL posts", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
            
            var idxArray = [IndexPath]()
            self.feedItemsList.enumerated().forEach({ idx, post in
                feedsProvider?.markAsDismissed(post)
                let idxP = IndexPath(row: idx, section: 0)
                idxArray.append(idxP)
            })
            self.feedItemsList.removeAll()
            self.tableView.deleteRows(at: idxArray, with: .automatic)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItemsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath) as! FeedItemCell

        // Configure the cell...
//        let item = FeedItem(id: "\(indexPath.row)", title: "title\(indexPath.row)", author: "author\(indexPath.row)", created: 1411975314, thumb_url: "www.a-thumbnail-url.com", comments: 23423)
//        cell.setItem(item)
        
        let item = feedItemsList[indexPath.row]
        cell.setItem(item)
        
        // image loading..
        imageLoader.load(from: item.imageUrl) { (image) in
            if let updateCell = tableView.cellForRow(at: indexPath) as? FeedItemCell {
                updateCell.postImageView.image = image
            }
        }
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = feedItemsList[indexPath.row]
        delegate?.postSelected(selectedPost)
        
        feedsProvider?.markAsRead(selectedPost)
        (tableView.cellForRow(at: indexPath) as? FeedItemCell)?.markAsRead()
        
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
}

extension MasterViewController: PostCellDelegate {
    func dismissPost(_ post: FeedItem) {
        if let idx = feedItemsList.firstIndex(of: post) {
            
            let msg = "Are you sure you want to dismiss this post?"
            let alert = UIAlertController(title: "Dismiss post", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                
                self.feedItemsList.remove(at: idx)
                let ip = IndexPath(row: idx, section: 0)
                self.tableView.deleteRows(at: [ip], with: .fade)
                
                feedsProvider?.markAsDismissed(post)
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
