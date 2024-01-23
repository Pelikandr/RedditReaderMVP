//
//  Reusable.swift
//  RedditReaderMVP
//
//  Created by TrackimoM1Pro on 07.01.2024.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseId: String { get }
}

extension Reusable where Self: UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}
