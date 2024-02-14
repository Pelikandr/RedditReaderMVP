//
//  UIImage+DiskSize.swift
//  ImageDownloadService
//
//  Created by Denys Zaiakin on 14.02.2024.
//

import UIKit

extension UIImage {
    var diskSize: Int {
        return self.cgImage?.bytesPerRow ?? 0 * (self.cgImage?.height ?? 0)
    }
}
