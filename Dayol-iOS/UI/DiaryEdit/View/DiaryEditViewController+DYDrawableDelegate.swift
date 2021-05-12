//
//  DiaryEditViewController+DYDrawableDelegate.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/26.
//

import UIKit

extension DiaryEditViewController: DYDrawableDelegate {

    func didTapEraseButton() {
        let isObjectErase = drawableViewModel.currentEraseTool.isObjectErase
        let eraseTool = DYEraseTool(isObjectErase: isObjectErase)
        diaryEditCoverView.diaryView.currentToolSubject.send(eraseTool)
    }

    func didTapPencilButton() {
        let pencilColor = drawableViewModel.currentPencilTool.color
        let isHighlighter = drawableViewModel.currentPencilTool.isHighlighter
        let pencilTool = DYPencilTool(color: pencilColor, isHighlighter: isHighlighter)
        diaryEditCoverView.diaryView.currentToolSubject.send(pencilTool)
    }

    func didTapTextButton(_ textField: UITextField) {
        diaryEditCoverView.diaryView.currentToolSubject.send(nil)
    }

    func didEndEraseSetting(eraseType: EraseType, isObjectErase: Bool) {
        let eraseTool = DYEraseTool(isObjectErase: isObjectErase)
        drawableViewModel.currentEraseTool = eraseTool
        diaryEditCoverView.diaryView.currentToolSubject.send(eraseTool)
    }

    func didEndPencilSetting(color: UIColor, isHighlighter: Bool) {
        let pencilTool = DYPencilTool(color: color, isHighlighter: isHighlighter)
        drawableViewModel.currentPencilTool = pencilTool
        diaryEditCoverView.diaryView.currentToolSubject.send(pencilTool)
    }

    func didEndTextStyle() {

    }

    func showStickerPicekr() {
        diaryEditCoverView.diaryView.currentToolSubject.send(nil)
    }

    func didEndPhotoPick(_ image: UIImage) {
        // 사용 예시 코드
        diaryEditCoverView.diaryView.currentToolSubject.send(nil)
        
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
