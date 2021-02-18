//
//  DataBackupCloudContentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/17.
//

import UIKit

private enum Design {
    static let contentBGColor = UIColor(decimalRed: 246, green: 248, blue: 250)
    static let contentCornerRadius: CGFloat = 12.0
    static let contentInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 19)

    static let titleColor = UIColor(decimalRed: 34, green: 34, blue: 34)
    static let titleSpacing: CGFloat = -0.31
    static let titleFont = UIFont.boldSystemFont(ofSize: 17.0)
}

private enum Text {
    static let title = "backup_icloud_title".localized
}

class DataBackupCloudContentView: UIView {

    // MARK: UI Porperty

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(text: Text.title,
                                                        font: Design.titleFont,
                                                        align: .center,
                                                        letterSpacing: Design.titleSpacing,
                                                        foregroundColor: Design.titleColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let actionSwitch: UISwitch = {
        let actionSwitch = UISwitch()
        actionSwitch.translatesAutoresizingMaskIntoConstraints = false
        return actionSwitch
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - Private initial function

private extension DataBackupCloudContentView {

    func initView() {
        backgroundColor = Design.contentBGColor
        layer.cornerRadius = Design.contentCornerRadius
        addSubview(titleLabel)
        addSubview(actionSwitch)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: Design.contentInset.left),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),


            actionSwitch.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -Design.contentInset.right),
            actionSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
