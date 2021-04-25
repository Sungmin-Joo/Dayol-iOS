//
//  DiaryEditViewController+ToolBar.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/03/29.
//

import UIKit
import RxCocoa
import RxSwift

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

extension DiaryEditViewController {

    func toolBarBind() {
        accessoryViewBind()
        lassoToolBind()
        eraseBind()
        penBind()
        textFieldBind()
        photoBind()
    }
}

extension DiaryEditViewController {

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

    private func eraseBind() {
        toolBar.eraserButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.currentTool == .eraser else {
                    self.currentTool = .eraser
                    return
                }
                let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .small)
                let modalVC = DYModalViewController(configure: configuration,
                                                    title: Text.eraseTitle,
                                                    hasDownButton: true)
                modalVC.contentView = EraseSettingView()
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
                    return
                }
                let configuration = DYModalConfiguration(dimStyle: .black, modalStyle: .custom(containerHeight: Design.penSettingModalHeight))
                let modalVC = DYModalViewController(configure: configuration,
                                                    title: Text.penTitle,
                                                    hasDownButton: true)
                modalVC.contentView = PencilSettingView(currentColor: .red)
                self.presentCustomModal(modalVC)
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
                    textField.backgroundColor = .darkGray
                    textField.frame.size = Design.defaultTextFieldSize
                    textField.frame.origin = .zero
                    self.diaryEditCoverView.diaryView.addSubview(textField)
                    textField.becomeFirstResponder()
                    return
                }
            }
            .disposed(by: disposeBag)
    }

    private func photoBind() {
        toolBar.photoButton.rx.tap
            .bind { [weak self] in
                self?.showPicker()
            }
            .disposed(by: disposeBag)
    }

}
