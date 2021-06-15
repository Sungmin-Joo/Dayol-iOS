//
//  DiaryPaperEditViewController+Drawable.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/15.
//

import UIKit
import Photos
import PhotosUI

// MARK: - Drawable

extension DiaryPaperEditViewController {

    // MARK: - Pencil

    func didTapPencilButton() {
        let pencilColor = currentPencilTool.color
        let isHighlighter = currentPencilTool.isHighlighter
        let pencilTool = DYPencilTool(color: pencilColor, isHighlighter: isHighlighter)
        paper.drawingContentView.currentToolSubject.onNext(pencilTool)
    }

    func didEndPencilSetting(color: UIColor, isHighlighter: Bool) {
        let pencilTool = DYPencilTool(color: color, isHighlighter: isHighlighter)
        currentPencilTool = pencilTool
        paper.drawingContentView.currentToolSubject.onNext(pencilTool)
    }

    // MARK: - Erase

    func didTapEraseButton() {
        let isObjectErase = currentEraseTool.isObjectErase
        let eraseTool = DYEraseTool(isObjectErase: isObjectErase)
        paper.drawingContentView.currentToolSubject.onNext(eraseTool)
    }

    func didEndEraseSetting(isObjectErase: Bool) {
        let eraseTool = DYEraseTool(isObjectErase: isObjectErase)
        currentEraseTool = eraseTool
        paper.drawingContentView.currentToolSubject.onNext(eraseTool)
    }

    // MARK: - TextField

    func didTapTextButton() {
        paper.drawingContentView.currentToolSubject.onNext(nil)
    }

    // MARK: - Snare(Lasso)

    func didTapSnareButton() {
        paper.drawingContentView.currentToolSubject.onNext(nil)
    }

    // MARK: - Image(Sticker)

    func showImagePicker() {
        paper.drawingContentView.currentToolSubject.onNext(nil)
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images])

            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)

        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                present(picker, animated: true)
            }
        }
    }

    func didEndPhotoPick(_ image: UIImage) {

    }

    // MARK: - DY Sticker

    func showStickerPicker() {
        paper.drawingContentView.currentToolSubject.onNext(nil)
    }

    func didEndStickerPick(_ image: UIImage) {
        // TODO: - 속지 내부 컨텐츠 연동하면서 로직 수정 필요
        // 현재는 이벤트 바인딩 용 로직 적용
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 76.0, height: 66.0)
        let stickerView = DYStickerSizeStretchableView(contentView: imageView)
        stickerView.alpha = 0.0
        stickerView.enableClose = true
        stickerView.enableRotate = true
        stickerView.enableHStretch = true
        stickerView.enableWStretch = true

        self.paper.addSubview(stickerView)

        stickerView.center = self.view.center

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            stickerView.alpha = 1.0
        }, completion: nil)
    }

}

// MARK: - Picker Delegate

extension DiaryPaperEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            didEndPhotoPick(image)
        }
        dismiss(animated: true, completion: nil)
    }

    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self, let image = image as? UIImage else { return }

                DispatchQueue.main.async {
                    self.didEndPhotoPick(image)
                }
            }
        }
    }
}
