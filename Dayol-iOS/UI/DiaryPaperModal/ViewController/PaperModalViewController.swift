//
//  PaperModalViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {

}

private enum Text {

}

class PaperModalViewController: DYModalViewController {

    enum PaperToolType {
        case add
        case list
    }

    private let disposeBag = DisposeBag()

    // MARK: - UI Property

    private lazy var addPaperHeaderView = AddPaperHeaderView()
    private lazy var addPaperContentView = AddPaperContentView()
    private lazy var paperListHeaderView = PaperListHeaderView()
    private lazy var paperListContentView = PaperListContentView()

    var toolType: PaperToolType

    init(toolType: PaperToolType, configure: DYModalConfiguration) {
        self.toolType = toolType
        super.init(configure: configure)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleArea()
        setupContentArea()
        bindEvent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        switch toolType {
        case .add:
            addPaperContentView.layoutCollectionView(width: size.width)
        case .list:
            paperListContentView.layoutCollectionView()
        }

    }

    private func setupTitleArea() {
        switch toolType {
        case .add:
            titleView = addPaperHeaderView
        case .list:
            titleView = paperListHeaderView
        }
    }

    private func setupContentArea() {
        switch toolType {
        case .add:
            contentView = addPaperContentView
        case .list:
            contentView = paperListContentView
        }
    }
}

private extension PaperModalViewController {

    func bindEvent() {
        switch toolType {
        case .add:
            bindAddPaperEvent()
        case .list:
            bindPaperListEvent()
        }
    }

    func bindAddPaperEvent() {
        addPaperHeaderView.barLeftButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        addPaperHeaderView.barRightButton.rx.tap
            .bind { [weak self] in
                // rx create event
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

    func bindPaperListEvent() {
        paperListHeaderView.closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

}
