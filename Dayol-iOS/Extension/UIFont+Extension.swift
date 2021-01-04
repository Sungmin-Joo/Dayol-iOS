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

}
