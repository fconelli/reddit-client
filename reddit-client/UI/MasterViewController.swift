//
//  MasterViewController.swift
//  reddit-client
//
//  Created by Francisco Conelli on 14/01/2021.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var feedItemsList:[FeedItem] = []
    var imageLoader = ImageLoader()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        
        // fire posts load...
        fetchRedditPosts()
    }
    
    private func setupViews() {
        self.tableView.register(UINib(nibName: "FeedItemCell", bundle: nil), forCellReuseIdentifier: "FeedItemCell")
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
            }
        }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
