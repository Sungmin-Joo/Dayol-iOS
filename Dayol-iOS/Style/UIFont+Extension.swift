//
//  UIFont+Extension.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import UIKit

extension UIFont {

    private static func nonOptionalFont(name: String?, _ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name ?? "", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    static func appleRegular(size: CGFloat) -> UIFont {
        return UIFont.nonOptionalFont(name: "AppleSDGothicNeo-Regular", size)
    }
    
    static func appleMedium(size: CGFloat) -> UIFont {
        return UIFont.nonOptionalFont(name: "AppleSDGothicNeo-Medium", size)
    }

    static func appleBold(size: CGFloat) -> UIFont {
        return UIFont.nonOptionalFont(name: "AppleSDGothicNeo-Bold", size)
    }

    static func helveticaBold(size: CGFloat) -> UIFont {
        return UIFont.nonOptionalFont(name: "Helvetica-Bold", size)
    }
}

extension UIFont {

    var canBold: Bool {
        return fontDescriptor.withSymbolicTraits(.traitBold) != nil
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var toBoldFont: UIFont {
        guard isBold == false else { return self }

        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.insert([.traitBold])

        if let fontDescriptor = fontDescriptor.withSymbolicTraits(symbolicTraits) {
            let fontSize = pointSize
            return UIFont(descriptor: fontDescriptor, size: fontSize)
        }

        return self
    }

    var toRegularFont: UIFont {
        guard isBold else { return self }

        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.remove([.traitBold])

        if let fontDescriptor = fontDescriptor.withSymbolicTraits(symbolicTraits) {
            let fontSize = pointSize
            return UIFont(descriptor: fontDescriptor, size: fontSize)
        }

        return self
    }

}
