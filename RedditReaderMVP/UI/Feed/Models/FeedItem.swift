//
//  FeedItem.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 07.01.2024.
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

enum PostHint: String, Decodable {
    case link = "link"
    case image = "image"
    case unknown = "unknown"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "link":                self = .link
        case "image":               self = .image
        default:                    self = .unknown
        }
    }
}

struct FeedItem: Decodable {
    let id: String
    let title: String
    let author: String
    let createdDate: Float
    let commentsNumber: Int
    let url: String
    let isVideo: Bool
    let postHint: PostHint?
    let permalink: String

    enum CodingKeys: String, CodingKey {
        case title, author, url, permalink
        case id = "name"
        case createdDate = "created"
        case commentsNumber = "num_comments"
        case isVideo = "is_video"
        case postHint = "post_hint"
    }
}
