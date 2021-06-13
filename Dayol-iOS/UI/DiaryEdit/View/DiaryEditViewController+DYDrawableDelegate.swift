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
        diaryEditCoverView.diaryView.currentToolSubject.onNext(eraseTool)
    }

    func didTapPencilButton() {
        let pencilColor = drawableViewModel.currentPencilTool.color
        let isHighlighter = drawableViewModel.currentPencilTool.isHighlighter
        let pencilTool = DYPencilTool(color: pencilColor, isHighlighter: isHighlighter)
        diaryEditCoverView.diaryView.currentToolSubject.onNext(pencilTool)
    }

    func didTapTextButton() {
        diaryEditCoverView.diaryView.currentToolSubject.onNext(nil)
        // TODO: - 탭 한 부분에 텍스트 필드를 생성하는 로직 추가
        let center = CGPoint(x: diaryEditCoverView.diaryView.bounds.width / 2.0,
                             y: diaryEditCoverView.diaryView.bounds.height / 2.0)
        let textField = DYFlexibleTextField()
        textField.center = center
        diaryEditCoverView.diaryView.addSubview(textField)
        let _ = textField.becomeFirstResponder()
    }

    func didEndEraseSetting(isObjectErase: Bool) {
        let eraseTool = DYEraseTool(isObjectErase: isObjectErase)
        drawableViewModel.currentEraseTool = eraseTool
        diaryEditCoverView.diaryView.currentToolSubject.onNext(eraseTool)
    }

    func didEndPencilSetting(color: UIColor, isHighlighter: Bool) {
        let pencilTool = DYPencilTool(color: color, isHighlighter: isHighlighter)
        drawableViewModel.currentPencilTool = pencilTool
        diaryEditCoverView.diaryView.currentToolSubject.onNext(pencilTool)
    }

    func showStickerPicker() {
        diaryEditCoverView.diaryView.currentToolSubject.onNext(nil)
    }

    func didEndPhotoPick(_ image: UIImage) {
        // 사용 예시 코드
        diaryEditCoverView.diaryView.currentToolSubject.onNext(nil)
        
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
        stickerView.center = diaryEditCoverView.diaryView.center
        diaryEditCoverView.diaryView.addSubview(stickerView)
    }

    func didEndStickerPick(_ image: UIImage) {

    }

}
