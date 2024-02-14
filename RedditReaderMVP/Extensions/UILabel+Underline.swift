//
//  UILabel+Underline.swift
//  RedditReaderMVP
//
//  Created by Denys Zaiakin on 15.02.2024.
//

import UIKit

extension UILabel {
    func underlineText() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
