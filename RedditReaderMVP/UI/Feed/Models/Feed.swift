//
//  Feed.swift
//  RedditReaderMVP
//
//  Created by TrackimoM1Pro on 07.01.2024.
//

import Foundation

struct Feed {
    let feedItems: [FeedItem]
    let loadNewItems: () -> Void
}
