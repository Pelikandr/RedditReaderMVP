//
//  FeedView.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 02.01.2024.
//

import UIKit

final class FeedView: UIView, XibLoadable {
    @IBOutlet private var tableView: UITableView!

    private var feedItems = [FeedItem]()

    private var loadNewItems: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupTableView()
    }

    func update(with model: Feed) {
        loadNewItems = model.loadNewItems
        feedItems = model.feedItems
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(reusableCell: FeedItemCell.self)
    }
}

// MARK: - UITabBarDelegate & DataSource
extension FeedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedItemCell.reuseId, for: indexPath) as? FeedItemCell else {
            fatalError("Unable to dequeue FeedItemCell")
        }

        let feedItem = feedItems[indexPath.row]
        cell.update(with: feedItem)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let feedItem = feedItems[indexPath.row]
        print(feedItem)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == feedItems.count - 1 else {
            return
        }

        loadNewItems?()
    }
}
