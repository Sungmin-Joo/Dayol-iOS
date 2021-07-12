//
//  PencilSettingSlider.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/12.
//

import UIKit

class PencilSettingSlider: UISlider {

    private let trackHeight: CGFloat
    init(trackHeight: CGFloat) {
        self.trackHeight = trackHeight
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = trackHeight
        newBounds.origin.y -= trackHeight / 2
        return newBounds
    }

    func setGradient(baseColor: UIColor) {
        let startColor = baseColor.withAlphaComponent(0)
        let endColor = baseColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint.init(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint.init(x:1.0, y:0.5)
        gradientLayer.cornerRadius = 8.0

        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, gradientLayer.isOpaque, 0.0);

        guard let currentContext = UIGraphicsGetCurrentContext() else { return }
        gradientLayer.render(in: currentContext)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()

            image.resizableImage(withCapInsets: UIEdgeInsets.zero)

            setMaximumTrackImage(image, for: .normal)
            setMinimumTrackImage(image, for: .normal)
        }
    }

}
