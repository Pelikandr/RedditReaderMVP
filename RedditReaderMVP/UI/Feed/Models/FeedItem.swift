//
//  FeedItem.swift
//  RedditReaderMVP
//
//  Created by TrackimoM1Pro on 07.01.2024.
//

import Foundation

struct FeedResponse: Decodable {
    let data: FeedItems
}

struct FeedItems: Decodable {
    let children: [FeedItemData]
}

struct FeedItemData: Decodable {
    let data: FeedItem
}

struct FeedItem: Decodable {
    let id: String
    let title: String
    let author: String
    let createdDate: Float
    let commentsNumber: Int
    let thumbnail: String
    let thumbnailHeight: Int?
    let thumbnailWidth: Int?
    let isVideo: Bool

    enum CodingKeys: String, CodingKey {
        case title, author, thumbnail
//        case title, author
//        case thumbnail = "url_overridden_by_dest"
        case id = "name"
        case createdDate = "created"
        case commentsNumber = "num_comments"
        case thumbnailHeight = "thumbnail_height"
        case thumbnailWidth = "thumbnail_width"
        case isVideo = "is_video"
    }
}
