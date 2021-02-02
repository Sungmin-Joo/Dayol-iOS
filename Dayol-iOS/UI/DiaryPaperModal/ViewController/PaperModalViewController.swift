//
//  AddPaperViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let titleFont = UIFont.appleBold(size: 18.0)
    static let titleLetterSpacing: CGFloat = -0.7
    static let titleColor = UIColor.black
    static let titleAreaSpacing: CGFloat = 8.0
}

private enum Text {
    static let title: String = "Diary.Page.Add.Title".localized
}

class AddPaperViewController: DYModalViewController {

    private let disposeBag = DisposeBag()

    // MARK: - UI Property

    private let barLeftButton = DYNavigationItemCreator.barButton(type: .cancel)
    private let barRightButton = DYNavigationItemCreator.barButton(type: .done)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(
            text: Text.title,
            font: Design.titleFont,
            align: .center,
            letterSpacing: Design.titleLetterSpacing,
            foregroundColor: Design.titleColor
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let addPaperContentView = AddPaperContentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleArea()
        setupContentArea()
        bindEvent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        addPaperContentView.layoutCollectionView(width: size.width)
    }

    private func setupTitleArea() {
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleView.addSubview(barLeftButton)
        titleView.addSubview(barRightButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        barLeftButton.translatesAutoresizingMaskIntoConstraints = false
        barRightButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),

            barLeftButton.topAnchor.constraint(equalTo: titleView.topAnchor,
                                               constant: Design.titleAreaSpacing),
            barLeftButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor,
                                                   constant: Design.titleAreaSpacing),

            barRightButton.topAnchor.constraint(equalTo: titleView.topAnchor,
                                                constant: Design.titleAreaSpacing),
            barRightButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor,
                                                     constant: -Design.titleAreaSpacing)

        ])

        self.titleView = titleView
    }

    private func setupContentArea() {
        self.contentView = addPaperContentView
    }
}

extension AddPaperViewController {

    private func bindEvent() {
        barLeftButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        barRightButton.rx.tap
            .bind { [weak self] in
                // rx create event
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

}
