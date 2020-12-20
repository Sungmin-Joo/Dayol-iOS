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
