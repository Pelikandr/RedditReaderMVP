//
//  EndPointType.swift
//  NetworkLayer
//
//  Created by Denys Zaiakin on 06.01.2024.
//

import Foundation

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

