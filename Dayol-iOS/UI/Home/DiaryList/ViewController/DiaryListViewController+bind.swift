//
//  DiaryListViewController+bind.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import UIKit
import RxSwift

private enum Design {
    static let iPadContentSize = CGSize(width: 375, height: 667)
    static let iPadContentCornerRadius: CGFloat = 12
}

// MARK: - Bind

extension DiaryListViewController {
    func bind() {
        iconButton.rx.tap
            .bind { [weak self] in
                let settingVC = SettingsViewController()
                let nav = DYNavigationController(rootViewController: settingVC)
                nav.modalPresentationStyle = isPadDevice ? .formSheet : .fullScreen

                if isPadDevice {
                    nav.preferredContentSize = Design.iPadContentSize
                    nav.view.layer.cornerRadius = Design.iPadContentCornerRadius
                }

                self?.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.diaryEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .fetch(let isEmpty):
                    guard isEmpty == false else {
                        self.showEmptyView()
                        return
                    }
                    self.hideEmptyView()
                    self.collectionView.reloadData()
                case .insert(let index):
                    print(index)
                case .delete(let index):
                    print(index)
                case .update(let index):
                    print(index)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Update

extension DiaryListViewController {

    private func showEmptyView() {
        emptyView.isHidden = false
    }

    private func hideEmptyView() {
        emptyView.isHidden = true
    }

}

// MARK: - Password View Controller Subjects

extension DiaryListViewController {
    func showPasswordViewController(diaryCover: Diary) {
        let coverColor: PaletteColor = PaletteColor.find(hex: diaryCover.colorHex) ?? .DYBrown
        // TODO: 패스워드 모델 정해지면 수정
        let passwordViewController = PasswordViewController(inputType: .check, diaryColor: coverColor)
        bindDidPassedPassword(passwordViewController, diaryCover: diaryCover)
        present(passwordViewController, animated: true, completion: nil)
    }
    
    func bindDidPassedPassword(_ viewController: PasswordViewController, diaryCover: Diary) {
        viewController.didPassedPassword
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showDiaryPaperViewController(diaryCover: diaryCover)
            })
            .disposed(by: disposeBag)
    }
    
    func showDiaryPaperViewController(diaryCover: Diary) {
        let diaryPaperViewModel = DiaryPaperViewerViewModel(coverModel: diaryCover)
        let diaryPaperViewController = DiaryPaperViewerViewController(viewModel: diaryPaperViewModel)
        let nav = DYNavigationController(rootViewController: diaryPaperViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
