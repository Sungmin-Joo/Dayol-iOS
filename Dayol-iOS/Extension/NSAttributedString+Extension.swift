//
//  NSAttributedString+Extension.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import UIKit

extension NSAttributedString {
    static func build(
        text: String,
        font: UIFont,
        align: NSTextAlignment,
        letterSpacing: CGFloat,
        foregroundColor: UIColor
    ) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = align

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: foregroundColor,
            .kern: letterSpacing
        ]

        return NSAttributedString(string: text, attributes: attributes)
    }
}
