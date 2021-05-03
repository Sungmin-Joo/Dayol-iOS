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
    func didTapTextButton(_ textField: UITextField)
    func didEndEraseSetting(eraseType: EraseType, isObjectErase: Bool)
    func didEndPencilSetting(color: UIColor, isHighlighter: Bool)
    func didEndTextStyle()
    func showStickerPicekr()
    func didEndPhotoPick(_ image: UIImage)
    func didEndStickerPick(_ image: UIImage)
}

private enum Design {
    static let defaultTextFieldSize = CGSize(width: 20, height: 30)
    static let penSettingModalHeight: CGFloat = 554.0
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
    let accessoryView = DYKeyboardInputAccessoryView(currentColor: .black)
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
        accessoryViewBind()
        lassoToolBind()
        eraseBind()
        penBind()
        textFieldBind()
        photoBind()
    }

    private func showEraseModal() {
        let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .small)
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.eraseTitle,
                                            hasDownButton: true)
        let isObjectErase = drawableViewModel.currentEraseTool.isObjectErase
        let contentView = EraseSettingView(currentEraseType: .small, isObjectErase: isObjectErase)
        modalVC.dismissCompeletion = { [weak self] in
            let newEraseType = contentView.currentEraseType
            let newIsObjectErase = contentView.isObjectErase
            self?.delegate?.didEndEraseSetting(eraseType: newEraseType, isObjectErase: newIsObjectErase)
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
        self.presentCustomModal(modalVC)
    }

}

// MARK: - Tool Bar Event

extension DYDrawableViewController {
    // TODO: - 텍스트 필드의 악세사리 뷰와 텍스트 필드를 동기화 해야함.
    // 추후에 accessoryView 관련 로직은 크게 변경될 여지가 있음.
    private func accessoryViewBind() {
        accessoryView.keyboardDownButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)

        accessoryView.textStyleButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)
                let configuration = DYModalConfiguration(dimStyle: .clear, modalStyle: .small)
                let modalVC = DYModalViewController(configure: configuration,
                                                    title: Text.textStyleTitle,
                                                    hasDownButton: true)
                let viewModel = TextStyleViewModel(alignment: .leading,
                                                   textSize: 16,
                                                   additionalOptions: [.bold],
                                                   lineSpacing: 26,
                                                   font: .sandolGodic)
                modalVC.contentView = TextStyleView(viewModel: viewModel)
                self.presentCustomModal(modalVC)
            }
            .disposed(by: disposeBag)

        accessoryView.textColorButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)
                // TODO: - 추후 컬러피커 완성되면 추가 예정
            }
            .disposed(by: disposeBag)
    }

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
                // TODO: - 다욜 텍스트 필드 구현 후 연동해야합니다.
                guard let self = self else { return }
                guard self.currentTool == .text else {
                    self.currentTool = .text
                    let textField = UITextField()
                    textField.inputAccessoryView = self.accessoryView
                    self.delegate?.didTapTextButton(textField)
                    return
                }
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
