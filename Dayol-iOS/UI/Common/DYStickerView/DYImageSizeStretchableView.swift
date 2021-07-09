//
//  DYImageSizeStretchableView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/14.
//

import UIKit

final class DYImageSizeStretchableView: DYStickerBaseView {

    init(contentView: UIImageView) {
        super.init(contentView: contentView)
        self.enableHStretch = true
        self.enableWStretch = true
        super.currentImage = contentView.image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(model: DecorationImageItem) {
        let image = UIImage(data: model.image)
        let imageView = UIImageView(image: image)
        self.init(contentView: imageView)
        frame = CGRect(x: CGFloat(model.x),
                       y: CGFloat(model.y),
                       width: CGFloat(model.width),
                       height: CGFloat(model.height))
        setDegree(CGFloat(model.inclination))
    }

    func toItem(id: String, parentId: String) -> DecorationImageItem? {
        guard let data = currentImage?.pngData() else { return nil }
        return DecorationImageItem(
            id: id,
            parentId: parentId,
            width: Float(frame.width),
            height: Float(frame.height),
            x: Float(frame.origin.x),
            y: Float(frame.origin.y),
            image: data,
            inclination: Float(deltaAngle)
        )
    }
}
