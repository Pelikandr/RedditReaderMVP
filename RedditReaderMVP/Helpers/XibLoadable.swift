//
//  XibLoadable.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 02.01.2024.
//

import UIKit

public protocol XibLoadable {
    static var xibName: String { get }
}

public extension XibLoadable where Self: UIView {
    static var xibName: String {
        return String(describing: self)
    }
    
    static func loadViewFromXib() -> Self {
        return Self.fromNib()	
    }
}

public extension XibLoadable {
    static func nib(bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: xibName, bundle: bundle)
    }
}

