//
//  AddPaperHeaderReusableView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/15.
//

import UIKit

private enum Design {
    static let backgroundColor = UIColor(decimalRed: 242, green: 244, blue: 246)

    static let titleFont = UIFont.appleRegular(size: 14.0)
    static let titleBoldFont = UIFont.appleBold(size: 14.0)
    static let titleColor = UIColor(white: 102.0 / 255.0, alpha: 1.0)
    static let titleSpacing: CGFloat = -0.26
}

private enum Text {

    static let portraitTitle = titleAttributedString(text: "Diary.Page.Add.Portrait.Title".localized,
                                                     boldString: "Diary.Page.Add.Portrait.Title.Bold".localized)
    static let landscapeTitle = titleAttributedString(text: "Diary.Page.Add.Landscape.Title".localized,
                                                      boldString: "Diary.Page.Add.Landscape.Title.Bold".localized)

    static func titleAttributedString(text: String, boldString: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString.build(text: text,
                                                               font: Design.titleFont,
                                                               align: .center,
                                                               letterSpacing: Design.titleSpacing,
                                                               foregroundColor: Design.titleColor)
        let nsString = NSString(string: text)
        let range = nsString.range(of: boldString)
        attributedString.addAttribute(.font,
                                      value: Design.titleBoldFont,
                                      range: range)
        return attributedString
    }
}

class AddPaperHeaderReusableView: UICollectionReusableView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Design.backgroundColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateTitleLabel(tabType: AddPaperModel.PaperOrientation) {
        let title = tabType == .portrait ? Text.portraitTitle : Text.landscapeTitle
        titleLabel.attributedText = title
    }

    private func setupView() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
