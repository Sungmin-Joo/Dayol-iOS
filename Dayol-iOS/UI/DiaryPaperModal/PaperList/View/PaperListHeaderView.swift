//
//  PaperListHeaderView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/02.
//

import UIKit

private enum Design {
    static let titleFont = UIFont.appleBold(size: 18.0)
    static let titleLetterSpacing: CGFloat = -0.7
    static let titleColor = UIColor.black
    static let chevronButtonWidth: CGFloat = 55.0
    static let chevronButtonHeight: CGFloat = 55.0
}

private enum Text {
    static let title: String = "Diary.Page.List.Title".localized
}

class PaperListHeaderView: UIView {

    // 내일 이미지 추가 요청
    private(set) var barRightButton = DYNavigationItemCreator.barButton(type: .downwardChevron)
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

    init() {
        super.init(frame: .zero)
        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

private extension PaperListHeaderView {

    func initView() {
        addSubview(titleLabel)
        addSubview(barRightButton)

        barRightButton.translatesAutoresizingMaskIntoConstraints = false
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            barRightButton.widthAnchor.constraint(equalToConstant: Design.chevronButtonWidth),
            barRightButton.heightAnchor.constraint(equalToConstant: Design.chevronButtonHeight),
            barRightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            barRightButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
