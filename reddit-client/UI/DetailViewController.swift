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
    @IBOutlet weak var noPostView: UIView!
    
    var post: FeedItem? {
        didSet {
            refreshUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // tap on image
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnImageViewAction)))
    }
    

    private func refreshUI() {
        loadViewIfNeeded()
        
        // no post selected?
        noPostView.isHidden = self.post != nil
        
        authorNameLabel.text = post?.author
        descriptionLabel.text = post?.title
        if let urlString = post?.imageUrl, let imageURL = URL(string: urlString), UIApplication.shared.canOpenURL(imageURL) {
            postImageView.load(url: imageURL)
        } else {
            let noImageUrl = URL(string: "https://www.reddit.com/static/noimage.png")!
            postImageView.load(url: noImageUrl)
        }
    }
    
    @objc private func tapOnImageViewAction() {
        guard let urlString = post?.imageFullSizeUrl, let imageURL = URL(string: urlString), !imageURL.absoluteString.isEmpty else { return }
         UIApplication.shared.open(imageURL, options: [:], completionHandler: nil)
    }
}

extension DetailViewController: PostSelectionDelegate {
    func postSelected(_ newPost: FeedItem) {
        post = newPost
    }
}
