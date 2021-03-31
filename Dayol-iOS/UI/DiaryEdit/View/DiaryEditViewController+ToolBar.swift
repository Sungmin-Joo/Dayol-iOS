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
}

private enum Text {
    static let eraseTitle = "edit_eraser_title".localized
}

extension DiaryEditViewController {

    func toolBarBind() {
        accessoryViewBind()
        eraseBind()
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
