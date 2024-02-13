//
//  UIImageView+Download.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 12.01.2024.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: String, placeholderImage: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {

        showLoadingIndicator()
        self.contentMode = contentMode

        ImageService.shared.downloadImage(from: url) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.image = response
                    completion?(response)
                }

            case .failure(let error):
                self?.image = placeholderImage
                completion?(nil)
                print(error)
            }

            self?.hideLoadingIndicator()
        }
    }
}

import UIKit

extension UIImageView {
    private var loadingImageViewTag: Int { return 999 }

    func showLoadingIndicator() {
        // Remove existing loading image view if present
        hideLoadingIndicator()

        // Create a rotating image view for loading
        let loadingImage = UIImage(named: "redditLogo")?.withRenderingMode(.alwaysTemplate)
        let loadingImageView = UIImageView(image: loadingImage)
        loadingImageView.tintColor = UIColor.gray // Customize the tint color if needed
        loadingImageView.tag = loadingImageViewTag
        addSubview(loadingImageView)

        // Set up constraints to center and size the loading image
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingImageView.widthAnchor.constraint(equalToConstant: 120),
            loadingImageView.heightAnchor.constraint(equalToConstant: 120),
            loadingImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        // Rotate the loading image
        rotateLoadingImage(loadingImageView)
    }

    func hideLoadingIndicator() {
        // Remove the loading image view from the superview
        if let loadingImageView = viewWithTag(loadingImageViewTag) as? UIImageView {
            loadingImageView.layer.removeAllAnimations()
            loadingImageView.removeFromSuperview()
        }
    }

    private func rotateLoadingImage(_ imageView: UIImageView) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude

        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

