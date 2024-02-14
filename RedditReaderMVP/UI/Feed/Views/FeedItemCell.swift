//
//  FeedItemCell.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 07.01.2024.
//

import ImageDownloadService
import UIKit

final class FeedItemCell: UITableViewCell, XibLoadable, Reusable {
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var postImageView: UIImageView!
    @IBOutlet private var commentsLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        timeLabel.text = nil
        titleLabel.text = nil
        titleLabel.attributedText = nil
        postImageView.image = nil
        postImageView.isHidden = false
        commentsLabel.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.layer.borderWidth = 1
        postImageView.layer.borderColor = UIColor.black.cgColor
        postImageView.layer.cornerRadius = 10
    }

    func update(with item: FeedItem) {
        postImageView.isHidden = item.postHint != .image
        authorLabel.text = item.author
        timeLabel.text = Date(timeIntervalSince1970: TimeInterval(item.createdDate)).formatted()
        titleLabel.text = item.title
        commentsLabel.text = "\(item.commentsNumber) coments"

        switch item.postHint {
        case .link:                 titleLabel.underlineText()
        case .image:                setupImage(with: item.url)
        default:                    break
        }
    }

    private func setupImage(with urlString: String) {
        postImageView.isHidden = false
        let loadingImage = UIImage(named: "redditLogo")!.withRenderingMode(.alwaysTemplate)
        postImageView.downloadImage(from: urlString, loadingImage: loadingImage) { [weak self] image in
            guard image == nil else {
                return
            }

            self?.postImageView.image = UIImage(named: "redditDeadLogo")!
        }
    }
}
