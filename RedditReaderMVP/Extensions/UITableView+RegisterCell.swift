//
//  UITableView+RegisterCell.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 07.01.2024.
//

import UIKit

extension UITableView {
    func register<T: Reusable>(reusableCell: T.Type) {
        // Registers class or UINib, depending on if the cell conforms to XibLoadable or not.
        guard let xibLoadableCell = T.self as? XibLoadable.Type else {
            register(T.self, forCellReuseIdentifier: reusableCell.reuseId)
            return
        }

        register(xibLoadableCell.nib(bundle: Bundle(for: T.self)),
                 forCellReuseIdentifier: reusableCell.reuseId)
    }
}
