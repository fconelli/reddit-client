import UIKit

class FeedItemCell: UITableViewCell {
  
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var readMarkView: UIView!
    @IBOutlet private weak var readMarkContainerView: UIView!
    @IBOutlet private weak var dismissPostButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    
    
    var item: FeedItem?
  
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor.black

        self.authorLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.authorLabel.textColor = UIColor.white
        
        self.dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.dateLabel.textColor = UIColor.systemGray4
        
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.titleLabel.textColor = UIColor.white
        
        self.commentsCountLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        self.commentsCountLabel.textColor = UIColor.systemOrange
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.darkGray
        
        accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView?.tintColor = .white
        
        self.readMarkView.layer.cornerRadius = self.readMarkView.frame.width / 2
        self.readMarkView.clipsToBounds = true
    }
    
    func setItem(_ item: FeedItem) {
        authorLabel.text = item.author
        titleLabel.text = item.title
        commentsCountLabel.text = "\(item.comments) comments"
        dateLabel.text = item.created.timeAgoDisplay()
        
        self.readMarkContainerView.isHidden = FeedsStorage.getReadPosts().contains(item.id)
    }
  
    func markAsRead() {
        readMarkContainerView.isHidden = true
    }

    @IBAction func dismissPostButtonAction(_ sender: Any) {
    }
}
