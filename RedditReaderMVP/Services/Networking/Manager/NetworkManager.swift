//
//  NetworkManager.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 07.01.2024.
//

import UIKit
import NetworkLayer

typealias ImageDownloadProgressHandler = (Float) -> Void

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<D, String> where D: Decodable {
    case success(D)
    case failure(String)
}

enum RequestResult<String> {
    case success
    case failure(String)
}

struct NetworkManager: Manager {
    static let environment: NetworkEnvironment = .production
    private let router = Router<RedditTarget>()

    func request<D>(target: RedditTarget, completion: @escaping (Result<D, String>) -> Void) where D: Decodable {
        router.request(target, completion: { data, response, error in
            if error != nil {
                completion(.failure("Please check your network connection."))
            }

            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkResponse.noData.rawValue))
                        return
                    }

                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(D.self, from: responseData)
                        completion(.success(apiResponse))
                    } catch {
                        print(error)
                        completion(.failure(NetworkResponse.unableToDecode.rawValue))
                    }

                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            }
        })
    }
}


protocol Manager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> RequestResult<String>
}

extension Manager {
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
