//
//  MediaTarget.swift
//  RedditReaderMVP
//
//  Created by TrackimoM1Pro on 12.01.2024.
//

import Foundation

enum MediaTarget {
    case downloadImage(downloadUrl: String)
}

extension MediaTarget: EndPointType {
    var baseURL: URL {
        switch self {
        case .downloadImage(let downloadUrl):
            return URL(string: downloadUrl)!
        }
    }

    var path: String {
        return ""
    }

    var httpMethod: HTTPMethod {
        .get
    }

    var task: HTTPTask {
        return .download(encoding: .jsonEncoding)
    }

    var headers: HTTPHeaders? {
        switch self {
        case .downloadImage:
            return nil
        }
    }
}
