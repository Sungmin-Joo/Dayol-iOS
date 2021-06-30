//
//  DrawableViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/23.
//

import UIKit
import PhotosUI
import RxSwift

class DrawableViewController: UIViewController, Drawable {
    let disposeBag = DisposeBag()

    final let toolBar = DYNavigationItemCreator.drawingFunctionToolbar()

    public var drawingContentView = DrawingContentView()
    final var currentTool: DYNavigationDrawingToolbar.ToolType?
    final var currentEraseTool: DYEraseTool = DYEraseTool(isObjectErase: false)
    final var currentPencilTool: DYPencilTool = DYPencilTool(color: .black, isHighlighter: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToolBarEvent()
    }

    // MARK: - 오버라이드하여 사용처에서 좌표 제어
    func didTapTextButton() {}
    /// 오버라이드하여 사용처에서 좌표 제어
    func didTapTextButton() {
        showTextFieldToast()
    }

    func bindDrawingContentViewBind() {
        drawingContentView.didEndCreateTextField = { [weak self] in
            self?.currentTool = nil
            self?.toolBar.textButton.isSelected = false
        }
    }

    func didEndPhotoPick(_ image: UIImage) {}
    func didEndStickerPick(_ image: UIImage) {}
}

// MARK: - Drawbale Function

extension DrawableViewController {

    final func showImagePicker() {
        drawingContentView.shouldMakeTextField = false

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

}

// MARK: - Photo Delegate

extension DrawableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

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

