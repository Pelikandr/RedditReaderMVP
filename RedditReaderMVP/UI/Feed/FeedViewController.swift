//
//  ViewController.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 02.01.2024.
//

import UIKit

final class FeedViewController: UIViewController {
    private let presenter = FeedPresenter()
    private let contentView = FeedView.loadViewFromXib()

    override func loadView() {
        super.loadView()
        view = contentView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Feed"
        presenter.setViewDelegate(self)
    }
}

// MARK: - FeedViewDelegate
extension FeedViewController: FeedViewDelegate {
    func updateFeed(with model: Feed) {
        contentView.update(with: model)
    }

    func openLink(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(url)
    }
}

