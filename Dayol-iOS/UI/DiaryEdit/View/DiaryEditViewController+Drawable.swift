//
//  DiaryEditViewController+Drawable.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/26.
//

import UIKit
import Photos
import PhotosUI

// MARK: - Drawable

extension DiaryEditViewController {

    // MARK: - Pencil

    func didTapPencilButton() {
        let pencilColor = currentPencilTool.color
        let isHighlighter = currentPencilTool.isHighlighter
        let pencilTool = DYPencilTool(color: pencilColor, isHighlighter: isHighlighter)
        diaryEditCoverView.diaryView.currentToolSubject.onNext(pencilTool)
    }

    func didEndPencilSetting(color: UIColor, isHighlighter: Bool) {
        let pencilTool = DYPencilTool(color: color, isHighlighter: isHighlighter)
        currentPencilTool = pencilTool
        diaryEditCoverView.diaryView.currentToolSubject.onNext(pencilTool)
    }

    // MARK: - Erase

    func didTapEraseButton() {
        let isObjectErase = currentEraseTool.isObjectErase
        let eraseTool = DYEraseTool(isObjectErase: isObjectErase)
        diaryEditCoverView.diaryView.currentToolSubject.onNext(eraseTool)
    }

    func didEndEraseSetting(isObjectErase: Bool) {
        let eraseTool = DYEraseTool(isObjectErase: isObjectErase)
        currentEraseTool = eraseTool
        diaryEditCoverView.diaryView.currentToolSubject.onNext(eraseTool)
    }

    // MARK: - TextField

    func didTapTextButton() {
        diaryEditCoverView.diaryView.currentToolSubject.onNext(nil)
        // TODO: - 탭 한 부분에 텍스트 필드를 생성하는 로직 추가
        let diaryID = viewModel.currentDiaryId ?? viewModel.diaryIdToCreate
        // TODO: - 탭 한 부분에 텍스트 필드를 생성하는 로직 추가
        // let convertedCenter = view.convert(view.center, to: diaryEditCoverView.diaryView)
        let convertedCenter = diaryEditCoverView.diaryView.center
        diaryEditCoverView.diaryView.createTextField(diaryID: diaryID, targetPoint: convertedCenter)
    }

    // MARK: - Snare(Lasso)

    func didTapSnareButton() {
        diaryEditCoverView.diaryView.currentToolSubject.onNext(nil)
    }

    // MARK: - Image(Sticker)

    func showImagePicker() {
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
        // 사용 예시 코드
        diaryEditCoverView.diaryView.currentToolSubject.onNext(nil)

        let imageView = UIImageView(image: image)
        let imageRatio = image.size.height / image.size.width
        let defaultImageWith: CGFloat = DYImageSizeStretchableView.defaultImageWidth
        let calcedImageHeight: CGFloat = imageRatio * DYImageSizeStretchableView.defaultImageWidth
        imageView.frame.size = CGSize(width: defaultImageWith, height: calcedImageHeight)

        let stickerView = DYImageSizeStretchableView(contentView: imageView)
        stickerView.enableClose = true
        stickerView.enableRotate = true
        stickerView.enableHStretch = true
        stickerView.enableWStretch = true
        stickerView.center = diaryEditCoverView.diaryView.center
        diaryEditCoverView.diaryView.addSubview(stickerView)
    }

    // MARK: - DY Sticker

    func showStickerPicker() {
        diaryEditCoverView.diaryView.currentToolSubject.onNext(nil)
    }

    func didEndStickerPick(_ image: UIImage) {

    }

}

extension DiaryEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

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
