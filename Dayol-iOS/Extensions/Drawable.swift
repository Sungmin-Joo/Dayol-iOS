//
//  Drawable.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/26.
//

import UIKit
import RxCocoa
import RxSwift

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

protocol Drawable: UIViewController {
    var disposeBag: DisposeBag { get }

    var toolBar: DYNavigationDrawingToolbar { get }
    var currentTool: DYNavigationDrawingToolbar.ToolType? { get set }
    var currentEraseTool: DYEraseTool { get set }
    var currentPencilTool: DYPencilTool { get set }

    func didTapEraseButton()
    func didEndEraseSetting(isObjectErase: Bool)

    func didTapPencilButton()
    func didEndPencilSetting(color: UIColor, isHighlighter: Bool)

    func didTapSnareButton()

    func didTapTextButton()

    func showImagePicker()
    func didEndPhotoPick(_ image: UIImage)

    func showStickerPicker()
    func didEndStickerPick(_ image: UIImage)
}

extension Drawable {

    func bindToolBarEvent() {
        lassoToolBind()
        eraseBind()
        penBind()
        textFieldBind()
        photoBind()
        stickerBind()
    }

    private func showEraseModal() {
        let modalHeight = DYModalViewController.headerAreaHeight + EraseSettingView.contentHeight
        let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .custom(containerHeight: modalHeight))
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.eraseTitle,
                                            hasDownButton: true)
        let isObjectErase = currentEraseTool.isObjectErase
        let contentView = EraseSettingView(isObjectErase: isObjectErase)
        modalVC.dismissCompeletion = { [weak self] in
            let newIsObjectErase = contentView.isObjectErase
            self?.didEndEraseSetting(isObjectErase: newIsObjectErase)
        }
        modalVC.contentView = contentView
        self.presentCustomModal(modalVC)
    }

    private func presentPencilModal() {
        let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .custom(containerHeight: Design.penSettingModalHeight))
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.penTitle,
                                            hasDownButton: true)
        let currentColor = currentPencilTool.color
        let isHighlighter = currentPencilTool.isHighlighter
        let currnetPencilType: PencilTypeSettingView.PencilType = isHighlighter ? .highlighter : .pen
        let contentView = PencilSettingView(currentColor: currentColor, pencilType: currnetPencilType)
        modalVC.dismissCompeletion = { [weak self] in
            let newColor = contentView.currentPencilInfo.color
            let newIsHighlighter = contentView.currentPencilInfo.pencilType == .highlighter ? true : false
            self?.didEndPencilSetting(color: newColor, isHighlighter: newIsHighlighter)
        }
        modalVC.contentView = contentView
        presentCustomModal(modalVC)
    }

    private func presentStickerModal() {
        let stickerModal = StickerModalViewContoller()
        presentCustomModal(stickerModal)

        stickerModal.didTappedSticker
            .subscribe(onNext: { stickerImage in
                guard let stickerImage = stickerImage else { return }
                self.didEndStickerPick(stickerImage)
            })
            .disposed(by: disposeBag)
    }

}

// MARK: - Tool Bar Event

extension Drawable {

    private func eraseBind() {
        toolBar.eraserButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.currentTool == .eraser else {
                    self.currentTool = .eraser
                    self.didTapEraseButton()
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
                    self.didTapSnareButton()
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
                    self.didTapPencilButton()
                    return
                }
                self.presentPencilModal()
            }
            .disposed(by: disposeBag)
    }

    private func textFieldBind() {
        toolBar.textButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.currentTool != .text else { return }
                self.currentTool = .text
                self.didTapTextButton()
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

    private func stickerBind() {
        toolBar.stickerButton.rx.tap
            .bind { [weak self] in
                self?.presentStickerModal()
            }
            .disposed(by: disposeBag)
    }

}
