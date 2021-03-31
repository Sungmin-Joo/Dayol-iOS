//
//  DiaryEditViewController+ToolBar.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/03/29.
//

import UIKit
import RxCocoa
import RxSwift

private enum Text {
    static let eraseTitle = "edit_eraser_title".localized
}

extension DiaryEditViewController {

    func toolBarBind() {
        eraseBind()
        photoBind()
    }
}

extension DiaryEditViewController {

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

    private func photoBind() {
        toolBar.photoButton.rx.tap
            .bind { [weak self] in
                self?.showPicker()
            }
            .disposed(by: disposeBag)
    }

}