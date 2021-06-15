//
//  DYDrawableViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/26.
//

import UIKit
import RxCocoa
import RxSwift
import Photos
import PhotosUI
import PencilKit

protocol DYDrawableDelegate: AnyObject {
    func didTapEraseButton()
    func didTapPencilButton()
    func didTapTextButton()
    func didEndEraseSetting(isObjectErase: Bool)
    func didEndPencilSetting(color: UIColor, isHighlighter: Bool)
    func showStickerPicker()
    func didEndPhotoPick(_ image: UIImage)
    func didEndStickerPick(_ image: UIImage)
}

private enum Design {
    static let defaultTextFieldSize = CGSize(width: 20, height: 30)
    static let penSettingModalHeight: CGFloat = 554.0
    static let textColorSettingModalHeight: CGFloat = 441.0
}

private enum Text {
    static var textStyleTitle: String {
        return "text_style_title".localized
    }
    static var textColorStyleTitle: String {
        return "text_style_color".localized
    }
    static var eraseTitle: String {
        return "edit_eraser_title".localized
    }
    static var lassoTitle: String {
        return "edit_lasso_title".localized
    }
    static var penTitle: String {
        return "edit_pen_title".localized
    }
}

class DYDrawableViewModel {
    var currentEraseTool: DYEraseTool = DYEraseTool(isObjectErase: false)
    var currentPencilTool: DYPencilTool = DYPencilTool(color: .black, isHighlighter: false)
}

class DYDrawableViewController: UIViewController {

    let disposeBag = DisposeBag()
    let toolBar = DYNavigationItemCreator.drawingFunctionToolbar()
    var currentTool: DYNavigationDrawingToolbar.ToolType?
    var drawableViewModel = DYDrawableViewModel()
    weak var delegate: DYDrawableDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToolBarEvent()
    }

}

extension DYDrawableViewController {

    private func bindToolBarEvent() {
        lassoToolBind()
        eraseBind()
        penBind()
        textFieldBind()
        photoBind()
    }

    private func showEraseModal() {
        let modalHeight = DYModalViewController.headerAreaHeight + EraseSettingView.contentHeight
        let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .custom(containerHeight: modalHeight))
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.eraseTitle,
                                            hasDownButton: true)
        let isObjectErase = drawableViewModel.currentEraseTool.isObjectErase
        let contentView = EraseSettingView(isObjectErase: isObjectErase)
        modalVC.dismissCompeletion = { [weak self] in
            let newIsObjectErase = contentView.isObjectErase
            self?.delegate?.didEndEraseSetting(isObjectErase: newIsObjectErase)
        }
        modalVC.contentView = contentView
        self.presentCustomModal(modalVC)
    }

    private func showPencilModal() {
        let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .custom(containerHeight: Design.penSettingModalHeight))
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.penTitle,
                                            hasDownButton: true)
        let currentColor = drawableViewModel.currentPencilTool.color
        let isHighlighter = drawableViewModel.currentPencilTool.isHighlighter
        let currnetPencilType: PencilTypeSettingView.PencilType = isHighlighter ? .highlighter : .pen
        let contentView = PencilSettingView(currentColor: currentColor, pencilType: currnetPencilType)
        modalVC.dismissCompeletion = { [weak self] in
            let newColor = contentView.currentPencilInfo.color
            let newIsHighlighter = contentView.currentPencilInfo.pencilType == .highlighter ? true : false
            self?.delegate?.didEndPencilSetting(color: newColor, isHighlighter: newIsHighlighter)
        }
        modalVC.contentView = contentView
        presentCustomModal(modalVC)
    }

}

// MARK: - Tool Bar Event

extension DYDrawableViewController {

    private func eraseBind() {
        toolBar.eraserButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.currentTool == .eraser else {
                    self.currentTool = .eraser
                    self.delegate?.didTapEraseButton()
                    return
                }
                self.showEraseModal()
            }
            .disposed(by: disposeBag)
    }

    private func lassoToolBind() {
        toolBar.snareButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.currentTool == .snare else {
                    self.currentTool = .snare
                    return
                }
                let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .small)
                let modalVC = DYModalViewController(configure: configuration,
                                                    title: Text.lassoTitle,
                                                    hasDownButton: true)
                modalVC.contentView = LassoInfoView()
                self.presentCustomModal(modalVC)
            }
            .disposed(by: disposeBag)
    }

    private func penBind() {
        toolBar.pencilButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.currentTool == .pencil else {
                    self.currentTool = .pencil
                    self.delegate?.didTapPencilButton()
                    return
                }

                self.showPencilModal()
            }
            .disposed(by: disposeBag)
    }

    private func textFieldBind() {
        toolBar.textButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.currentTool != .text else { return }
                self.currentTool = .text
                self.delegate?.didTapTextButton()
                return
            }
            .disposed(by: disposeBag)
    }

    private func photoBind() {
        toolBar.photoButton.rx.tap
            .bind { [weak self] in
                self?.showImagePicker()
            }
            .disposed(by: disposeBag)
    }

}

extension DYDrawableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.didEndPhotoPick(image)
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
                    self.delegate?.didEndPhotoPick(image)
                }
            }
        }
    }
}
