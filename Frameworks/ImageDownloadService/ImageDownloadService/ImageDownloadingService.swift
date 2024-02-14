//
//  ImageService.swift
//  ImageDownloadingService
//
//  Created by Denys Zaiakin on 12.01.2024.
//

import UIKit

public protocol ImageService {
    func downloadImage(from url: String, completion: @escaping (ImageResult<UIImage, String>) -> Void)
}

public class ImageDownloadingService: ImageService {
    private let cache = NSCache<NSString, UIImage>()
    private let cacheLock = NSLock()
    private let cacheClearInterval: TimeInterval

    private var cacheClearTimer: Timer?

    private let networkManager = MediaNetworkManager()

    public static let shared = ImageDownloadingService()

    init(maxMemoryCapacity: Int = 50 * 1024 * 1024,
         cacheClearInterval: TimeInterval = 5 * 60) {
        self.cacheClearInterval = cacheClearInterval
        cache.totalCostLimit = maxMemoryCapacity
        startCacheClearTimer()
    }

    deinit {
        stopCacheClearTimer()
    }

    public func downloadImage(from url: String, completion: @escaping (ImageResult<UIImage, String>) -> Void) {
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
}

// MARK: - Cache
extension ImageDownloadingService {
    private func startCacheClearTimer() {
        cacheClearTimer = Timer.scheduledTimer(withTimeInterval: cacheClearInterval, repeats: true) { [weak self] _ in
            self?.clearCache()
        }
    }

    private func stopCacheClearTimer() {
        cacheClearTimer?.invalidate()
        cacheClearTimer = nil
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
