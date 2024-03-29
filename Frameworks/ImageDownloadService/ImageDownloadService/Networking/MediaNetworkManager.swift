//
//  MediaNetworkManager.swift
//  ImageDownloadingService
//
//  Created by Denys Zaiakin on 14.02.2024.
//

import UIKit
import NetworkLayer

typealias ImageDownloadProgressHandler = (Float) -> Void

public enum ImageResult<UIImage, String>{
    case success(UIImage)
    case failure(String)
}

struct MediaNetworkManager: Manager {
    private let router = Router<MediaTarget>()

    func downloadImage(from url: String, completion: @escaping (ImageResult<UIImage, String>) -> Void) {
        let target = MediaTarget.downloadImage(downloadUrl: url)
        router.request(target, completion: { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(error?.localizedDescription ?? "Response is nil"))
                return
            }

            let result = handleNetworkResponse(response)
            switch result {
            case .success:
                guard let data else {
                    completion(.failure(NetworkResponse.noData.rawValue))
                    return
                }

                guard let mimeType = response.mimeType,
                      mimeType.hasPrefix("image"),
                      let image = UIImage(data: data) else {
                    completion(.failure("No image found"))
                    return
                }

                completion(.success(image))

            case .failure(let networkFailureError):
                completion(.failure(networkFailureError))
            }
        })
    }
}
