//
//  Feed.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 07.01.2024.
//

import Foundation

struct Feed {
    let newFeedItems: [FeedItem]
    let loadNewItems: () -> Void
    let openLink: (String) -> Void
}
