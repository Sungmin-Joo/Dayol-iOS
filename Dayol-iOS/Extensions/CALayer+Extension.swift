//
//  CALayer+Extension.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/15.
//

import UIKit

// MARK: shadow

extension CALayer {
    /*
     워닝 해결해주세요 @주성민
     The layer is using dynamic shadows which are expensive to render. If possible try setting 'shadowPath', or pre-rendering the shadow into an image and putting it under the layer.
     */
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
