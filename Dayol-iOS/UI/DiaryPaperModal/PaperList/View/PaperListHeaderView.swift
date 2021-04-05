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
    static let closeButtonWidth: CGFloat = 55.0
    static let closeButtonHeight: CGFloat = 55.0

    static let closeButtonImage: UIImage? = UIImage(named: "downwardArrowButton")
}

private enum Text: String {
    case title = "page_title"
    
    var stringValue: String {
        return self.rawValue.localized
    }
}

class PaperListHeaderView: UIView {

    private(set) var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.closeButtonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(
            text: Text.title.stringValue,
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
        addSubview(closeButton)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            closeButton.widthAnchor.constraint(equalToConstant: Design.closeButtonWidth),
            closeButton.heightAnchor.constraint(equalToConstant: Design.closeButtonHeight),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
