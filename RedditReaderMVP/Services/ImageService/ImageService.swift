//
//  ImageService.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 12.01.2024.
//

import UIKit

final class ImageService {
    private let cache = NSCache<NSString, UIImage>()
    private let cacheLock = NSLock()
    private let maxMemoryCapacity: Int
    private let cacheClearInterval: TimeInterval = 60 * 60

    private var cacheClearTimer: Timer?

    private let networkManager = MediaNetworkManager()

    static let shared = ImageService()

    init(maxMemoryCapacity: Int = 50 * 1024 * 1024) {
        self.maxMemoryCapacity = maxMemoryCapacity
        cache.totalCostLimit = maxMemoryCapacity
        startCacheClearTimer()
    }

    deinit {
        stopCacheClearTimer()
    }

    private func startCacheClearTimer() {
        cacheClearTimer = Timer.scheduledTimer(withTimeInterval: cacheClearInterval, repeats: true) { [weak self] _ in
            self?.clearCache()
        }
    }

    private func stopCacheClearTimer() {
        cacheClearTimer?.invalidate()
        cacheClearTimer = nil
    }

    func downloadImage(from url: String, completion: @escaping (ImageResult<UIImage, String>) -> Void) {
        guard URL(string: url) != nil else {
            print("Invalid URL: \(url)")
            completion(.failure(""))
            return
        }

        if let cachedImage = getCachedImage(for: url) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }

            return
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            MediaNetworkManager().downloadImage(from: url) { result in
                switch result {
                case .success(let response):
                    self.cacheImage(response, for: url)

                    DispatchQueue.main.async {
                        completion(.success(response))
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }


    private func getCachedImage(for key: String) -> UIImage? {
        cacheLock.lock()
        defer {
            cacheLock.unlock()
        }

        return cache.object(forKey: key as NSString)
    }

    private func cacheImage(_ image: UIImage, for key: String) {
        cacheLock.lock()
        defer {
            cacheLock.unlock()
        }

        cache.setObject(image, forKey: key as NSString, cost: image.diskSize)
    }

    private func clearCache() {
        cacheLock.lock()
        defer {
            cacheLock.unlock()
        }

        cache.removeAllObjects()
    }
}

extension UIImage {
    var diskSize: Int {
        return self.cgImage?.bytesPerRow ?? 0 * (self.cgImage?.height ?? 0)
    }
}
