//
//  HTTPTask.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 06.01.2024.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request

    case requestParameters(
        bodyParameters: Parameters? = nil,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters? = nil)

    case requestParametersAndHeaders(
        bodyParameters: Parameters? = nil,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters? = nil,
        additionHeaders: HTTPHeaders? = nil)

    case download(
        parameters: Parameters? = nil,
        encoding: ParameterEncoding)
}
