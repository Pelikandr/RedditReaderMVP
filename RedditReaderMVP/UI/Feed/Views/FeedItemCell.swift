//
//  FeedItemCell.swift
//  RedditReaderMVP
//
//  Created by TrackimoM1Pro on 07.01.2024.
//

import UIKit

final class FeedItemCell: UITableViewCell, XibLoadable, Reusable {
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var commentsLabel: UILabel!

    @IBOutlet private var thumbnailHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var thumbnailWidthConstraint: NSLayoutConstraint!

    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        timeLabel.text = nil
        titleLabel.text = nil
        thumbnailImageView.image = nil
        commentsLabel.text = nil
        thumbnailHeightConstraint.constant = 72
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.borderWidth = 1
        thumbnailImageView.layer.borderColor = UIColor.black.cgColor
        thumbnailImageView.layer.cornerRadius = 10
    }

    func update(with item: FeedItem) {
        if let thumbnailHeight = item.thumbnailHeight {
            thumbnailHeightConstraint.constant = CGFloat(thumbnailHeight)
        }

        if let thumbnailWidth = item.thumbnailWidth {
            thumbnailWidthConstraint.constant = CGFloat(thumbnailWidth)
        }

        thumbnailImageView.downloadImage(from: item.thumbnail) { [weak self] image in
            guard image == nil else {
                return
            }

            self?.thumbnailImageView.image = UIImage(named: "redditDeadLogo")!
        }
        
        authorLabel.text = item.author
        timeLabel.text = Date(timeIntervalSince1970: TimeInterval(item.createdDate)).formatted()
        titleLabel.text = item.title
        commentsLabel.text = "\(item.commentsNumber) coments"
    }
}
