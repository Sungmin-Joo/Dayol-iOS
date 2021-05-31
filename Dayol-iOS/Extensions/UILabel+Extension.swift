//
//  UILabel+Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/19.
//

import UIKit

extension UILabel {
    var mutableAttributedString: NSMutableAttributedString? {
        if let attributedText = attributedText {
            return NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text {
            return NSMutableAttributedString(string: text)
        } else {
            return nil
        }
    }

    var attributedStringRange: NSRange {
        guard let attributedString = mutableAttributedString else { return NSRange(location: .zero, length: .zero) }
        return NSRange(location: .zero, length: attributedString.string.count)
    }

    func addLetterSpacing(_ spacing: CGFloat) {
        guard let attributedString = mutableAttributedString else { return }
        attributedString.addAttribute(.kern, value: spacing, range: attributedStringRange)
        attributedText = attributedString
    }

    func adjustPartialStringFont(_ partStrings: [String], partFont: UIFont) {
        partStrings.forEach {
            guard
                let partRange: NSRange = (mutableAttributedString?.string as NSString?)?.range(of: $0),
                let attributedString = mutableAttributedString
            else {
                return
            }

            attributedString.addAttribute(.font, value: partFont, range: partRange)
            attributedText = attributedString
        }
    }
}
