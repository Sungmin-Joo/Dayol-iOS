//
//  LabelUnderTheImageButton.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/03/30.
//

import UIKit

class LabelUnderTheImageButton: UIButton {

    var spacing: CGFloat

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let superRect = super.titleRect(forContentRect: contentRect)
        return CGRect(
            x: 0,
            y: contentRect.height - superRect.height,
            width: contentRect.width,
            height: superRect.height
        )
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let superRect = super.imageRect(forContentRect: contentRect)
        return CGRect(
            x: contentRect.width / 2 - superRect.width / 2,
            y: 0,
            width: superRect.width,
            height: superRect.height
        )
    }

    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        guard let image = imageView?.image else { return superSize }
        let size = titleLabel?.sizeThatFits(contentRect(forBounds: bounds).size) ?? .zero
        return CGSize(width: max(size.width, image.size.width), height: image.size.height + size.height + spacing)
    }

    init(spacing: CGFloat) {
        self.spacing = spacing
        super.init(frame: .zero)
        titleLabel?.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
