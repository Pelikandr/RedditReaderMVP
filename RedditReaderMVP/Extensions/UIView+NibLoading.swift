//
//  UIView+NibLoading.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 02.01.2024.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
