//
//  UIColor+Extension.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import UIKit

extension UIColor {
    convenience init(
        decimalRed: Int,
        green: Int,
        blue: Int,
        alpha: CGFloat = 1.0
    ) {
        self.init(
            red: CGFloat(decimalRed) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - Dayol Common Color

extension UIColor {
    @nonobjc class var splashBackground: UIColor {
        return UIColor(red: 253 / 255, green: 243 / 255, blue: 236 / 255, alpha: 1.0)
    }
    @nonobjc class var dayolBrown: UIColor {
        return UIColor(red: 187.0 / 255.0, green: 120.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var dayolRed: UIColor {
        return UIColor(red: 233.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    @nonobjc class var gray100: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 248.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray150: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 242.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray200: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 242.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray300: UIColor {
        return UIColor(red: 232.0 / 255.0, green: 234.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray400: UIColor {
        return UIColor(white: 216.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray600: UIColor {
        return UIColor(white: 176.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray700: UIColor {
        return UIColor(white: 153.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray800: UIColor {
        return UIColor(white: 102.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray900: UIColor {
        return UIColor(white: 34.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var black: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }

}
