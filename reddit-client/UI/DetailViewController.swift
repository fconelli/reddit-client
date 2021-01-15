//
//  DetailViewController.swift
//  reddit-client
//
//  Created by Francisco Conelli on 14/01/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var post: FeedItem? {
        didSet {
            refreshUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    private func refreshUI() {
        loadViewIfNeeded()
        authorNameLabel.text = post?.author
        descriptionLabel.text = post?.title
        if let urlString = post?.imageUrl, let imageURL = URL(string: urlString) {
            postImageView.load(url: imageURL)
        }
    }
}

extension DetailViewController: PostSelectionDelegate {
    func postSelected(_ newPost: FeedItem) {
        post = newPost
    }
}
