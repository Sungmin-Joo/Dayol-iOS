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

// MARK: - Hex Color

extension UIColor {

    /// "#FFFFFF" 형식의 hexString을 사용하여 UIColor 생성
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        if hexFormatted.count != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

    var toHexString: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
