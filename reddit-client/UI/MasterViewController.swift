//
//  MasterViewController.swift
//  reddit-client
//
//  Created by Francisco Conelli on 14/01/2021.
//

import UIKit

protocol PostSelectionDelegate: class {
  func postSelected(_ newPost: FeedItem)
}

class MasterViewController: UITableViewController {
    
    var feedItemsList:[FeedItem] = []
    var imageLoader = ImageLoader()
    weak var delegate: PostSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        
        // fire posts load...
        fetchRedditPosts()
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.black
        
        self.tableView.register(UINib(nibName: "FeedItemCell", bundle: nil), forCellReuseIdentifier: "FeedItemCell")
        
        // Add Refresh Control to Table View
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.gray
        
        // Configure Refresh Control
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - fetch data
    private func fetchRedditPosts() {
        var urlSession: URLSession
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration)
        
        let client = URLSessionHTTPClient(session: urlSession)
        let loader = RemoteFeedLoader(client: client)
        loader.load() { result in
            switch result {
            case let .success(list):
                self.feedItemsList = list
            case .failure:
                break
            }
            DispatchQueue.main.async() {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.refreshControl?.beginRefreshing()
        fetchRedditPosts()
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = feedItemsList[indexPath.row]
        delegate?.postSelected(selectedPost)
        
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
}
