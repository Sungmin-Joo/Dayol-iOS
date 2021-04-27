//
//  DiaryEditViewController+DYDrawableDelegate.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/26.
//

import UIKit

extension DiaryEditViewController: DYDrawableDelegate {

    func didTapEraseButton() {

    }

    func didTapPencilButton() {

    }

    func didTapTextButton(_ textField: UITextField) {

    }

    func didEndEraseSetting(eraseType: EraseType, isObjectErase: Bool) {

    }

    func didEndPencilSetting() {

    }

    func didEndTextStyle() {

    }

    func showStickerPicekr() {

    }

    func didEndPhotoPick(_ image: UIImage) {
        // 사용 예시 코드
        let imageView = UIImageView(image: image)
        let imageRatio = image.size.height / image.size.width
        let defaultImageWith: CGFloat = 76.0
        let calcedImageHeight: CGFloat = imageRatio * 76.0
        imageView.frame.size = CGSize(width: defaultImageWith, height: calcedImageHeight)

        let stickerView = DYStickerSizeStretchableView(contentView: imageView)
        stickerView.enableClose = true
        stickerView.enableRotate = true
        stickerView.enableHStretch = true
        stickerView.enableWStretch = true
        stickerView.center = view.center
        view.addSubview(stickerView)
    }

    func didEndStickerPick(_ image: UIImage) {

    }

}
