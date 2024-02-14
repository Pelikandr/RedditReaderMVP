//
//  FeedPresenter.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 02.01.2024.
//

import Foundation

protocol FeedViewDelegate: NSObjectProtocol {
    func updateFeed(with model: Feed)
    func openLink(_ urlString: String)
}

final class FeedPresenter {
    private let networkManager: NetworkManager

    weak private var delegate: FeedViewDelegate?

    private var feedItems = [FeedItem]()
    private var lastPostId: String? {
        return feedItems.last?.id
    }

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func setViewDelegate(_ delegate: FeedViewDelegate?){
        self.delegate = delegate
    }

    func viewDidAppear() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.getNewFeedItems()
        }
    }
}

// MARK: - Private
extension FeedPresenter {
    private func updateModel(with newItems: [FeedItem]) {
        let model = Feed(
            newFeedItems: newItems,
            loadNewItems: { [weak self] in
                self?.getNewFeedItems()
            },
            openLink: { [weak self] urlString in
                self?.delegate?.openLink(urlString)
            })
        
        delegate?.updateFeed(with: model)
    }

    // MARK: - Networking
    private func getNewFeedItems() {
        let target = RedditTarget.feed(after: lastPostId)
        networkManager.request(target: target, completion: { [weak self] (result: Result<FeedResponse, String>) in
            switch result {
            case .success(let response):
                var newItems: [FeedItem] = []
                response.data.children.forEach {
                    guard !$0.data.isVideo else {
                        return
                    }
                    
                    newItems.append($0.data)
                }

                self?.feedItems.append(contentsOf: newItems)
                DispatchQueue.main.async {
                    self?.updateModel(with: newItems)
                }

            case .failure(let error):
                print(error)
            }
        })
    }
}
