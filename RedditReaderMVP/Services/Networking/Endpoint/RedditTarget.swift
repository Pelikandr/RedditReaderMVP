//
//  RedditTarget.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 07.01.2024.
//

import NetworkLayer

enum NetworkEnvironment {
    case dev
    case stg
    case prod
}

enum RedditTarget {
    case feed(after: String?, limit: Int = 10)
}

extension RedditTarget: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .dev:                              return "https://www.reddit.com/"
        case .stg:                              return "https://www.reddit.com/"
        case .prod:                             return "https://www.reddit.com/"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .feed:                             return "top.json"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .feed:                             return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .feed(let after, let limit):
            let parameters = ["after": after ?? "",
                              "limit": limit] as [String: Any]
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: parameters)
        }

    }

    var headers: HTTPHeaders? {
        return nil
    }
}
