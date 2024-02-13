//
//  EndPointType.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 06.01.2024.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

