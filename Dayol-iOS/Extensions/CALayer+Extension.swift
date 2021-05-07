//
//  CALayer+Extension.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/15.
//

import UIKit

// MARK: shadow

extension CALayer {
    func setZepplinShadow(
        x width: CGFloat,
        y height: CGFloat,
        blur: CGFloat,
        color: UIColor,
        spread: CGFloat = .zero,
        opacity: Float = 1.0
    ) {
        shadowOffset = CGSize(width: width, height: height)
        shadowColor = color.cgColor
        shadowRadius = blur / 2.0
        shadowOpacity = opacity

        if spread == .zero {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
