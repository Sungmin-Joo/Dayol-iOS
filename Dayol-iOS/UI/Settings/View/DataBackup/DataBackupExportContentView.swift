//
//  DataBackupExportContentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/18.
//

import UIKit

private enum Design {
    static let nextIconImage = Assets.Image.Settings.Backup.next
    static let infoIconImage = Assets.Image.Settings.Backup.info

    static let contentBGColor = UIColor(decimalRed: 246, green: 248, blue: 250)
    static let contentCornerRadius: CGFloat = 12.0

    static let titleColor = UIColor(decimalRed: 34, green: 34, blue: 34)
    static let titleSpacing: CGFloat = -0.31
    static let titleFont = UIFont.boldSystemFont(ofSize: 17.0)
    static let titleInset = UIEdgeInsets(top: 18, left: 20, bottom: 0, right: 0)

    static let infoColor = UIColor(decimalRed: 102, green: 102, blue: 102)
    static let infoFont = UIFont.appleBold(size: 14.0)
    static let infoSpacing: CGFloat = -0.26
    static let infoInset = UIEdgeInsets(top: 19, left: 20, bottom: 0, right: 0)

    static let textColor = UIColor(decimalRed: 102, green: 102, blue: 102)
    static let textFont = UIFont.appleRegular(size: 14.0)
    static let textBoldFont = UIFont.appleBold(size: 14.0)
    static let textSpacing: CGFloat = -0.26
    static let textInset = UIEdgeInsets(top: 10, left: 20, bottom: 18, right: 20)

}

private enum Text {
    static let title = "backup_export_title".localized
    static let info = "backup_export_info".localized
    static let text = "backup_export_text".localized

    static var textBoldRange: NSRange {
        let nsString = NSString(string: text)
        return nsString.range(of: "backup_export_text_bold".localized)
    }
}

class DataBackupExportContentView: UIView {
    let titleTapGesture = UITapGestureRecognizer()

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
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        let titleIconImageView = UIImageView(image: Design.nextIconImage)
        titleIconImageView.frame.size = Design.nextIconImage?.size ?? .zero
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.alignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleIconImageView)
        stackView.addGestureRecognizer(titleTapGesture)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(text: Text.info,
                                                        font: Design.infoFont,
                                                        align: .center,
                                                        letterSpacing: Design.infoSpacing,
                                                        foregroundColor: Design.infoColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        let infoIconImageView = UIImageView(image: Design.infoIconImage)
        infoIconImageView.frame.size = Design.infoIconImage?.size ?? .zero
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.alignment = .center
        stackView.addArrangedSubview(infoIconImageView)
        stackView.addArrangedSubview(infoLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString.build(text: Text.text,
                                                               font:  Design.textFont,
                                                               align: .left,
                                                               letterSpacing: Design.textSpacing,
                                                               foregroundColor: Design.textColor)
        attributedString.addAttribute(.font,
                                      value: Design.textBoldFont,
                                      range: Text.textBoldRange)
        label.attributedText = attributedString
        label.numberOfLines = 0
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

// MARK: - Private initial function

private extension DataBackupExportContentView {

    func initView() {
        backgroundColor = Design.contentBGColor
        layer.cornerRadius = Design.contentCornerRadius

        addSubview(titleStackView)
        addSubview(infoStackView)
        addSubview(textLabel)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: topAnchor,
                                                constant: Design.titleInset.top),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: Design.titleInset.left),

            infoStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor,
                                               constant: Design.infoInset.top),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Design.infoInset.left),

            textLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor,
                                           constant: Design.textInset.top),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: Design.textInset.left),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -Design.textInset.right),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -Design.textInset.bottom),


        ])
    }

    func bindEvent() {

    }
}


