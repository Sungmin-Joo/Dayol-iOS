//
//  DYImageSizeStretchableView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/14.
//

import UIKit

final class DYImageSizeStretchableView: DYStickerBaseView {

    static let defaultImageWidth: CGFloat = 76.0

    var currentImage: UIImage?

    init(contentView: UIImageView) {
        super.init(contentView: contentView)
        self.enableHStretch = true
        self.enableWStretch = true
        self.currentImage = contentView.image
    }

    convenience init(image: UIImage) {
        let imageView = UIImageView(image: image)
        let imageRatio = image.size.height / image.size.width
        let calcedImageHeight: CGFloat = imageRatio * Self.defaultImageWidth
        imageView.frame.size = CGSize(width: Self.defaultImageWidth, height: calcedImageHeight)
        self.init(contentView: imageView)
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toItem(id: String, parentId: String) -> DecorationImageItem? {
        guard let data = currentImage?.pngData() else { return nil }
        return DecorationImageItem(id: id,
                                   parentId: parentId,
                                   width: Float(frame.width),
                                   height: Float(frame.height),
                                   x: Float(frame.origin.x),
                                   y: Float(frame.origin.y),
                                   image: data,
                                   inclination: Float(deltaAngle))
    }
}
