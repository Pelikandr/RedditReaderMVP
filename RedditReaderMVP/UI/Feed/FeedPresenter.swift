//
//  FeedPresenter.swift
//  RedditReaderMVP
//
//  Created by TrackimoM1Pro on 02.01.2024.
//

import Foundation

protocol FeedViewDelegate: NSObjectProtocol {
    func updateFeed(with model: Feed)
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
    private func updateModel() {
        let model = Feed(
            feedItems: feedItems,
            loadNewItems: { [weak self] in
                self?.getNewFeedItems()
            })
        
        delegate?.updateFeed(with: model)
    }

    // MARK: - Networking
    private func getNewFeedItems() {
        let target = RedditTarget.feed(after: lastPostId)
        networkManager.request(target: target, completion: { [weak self] (result: Result<FeedResponse, String>) in
            switch result {
            case .success(let response):
                response.data.children.forEach {
                    self?.feedItems.append($0.data)
                }

                DispatchQueue.main.async {
                    self?.updateModel()
                }

            case .failure(let error):
                print(error)
            }
        })
    }
}
