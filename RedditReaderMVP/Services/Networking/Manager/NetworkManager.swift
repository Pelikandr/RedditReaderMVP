//
//  NetworkManager.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 07.01.2024.
//

import UIKit
import NetworkLayer

enum Result<D, String> where D: Decodable {
    case success(D)
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
