//
//  Manager.swift
//  NetworkLayer
//
//  Created by Denys Zaiakin on 14.02.2024.
//

import Foundation

public enum RequestResult<String> {
    case success
    case failure(String)
}

public enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

public protocol Manager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> RequestResult<String>
}

public extension Manager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> RequestResult<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
