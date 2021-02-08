//
//  PaperListAddCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/03.
//

import UIKit

private enum Design {

    static let titleFont = UIFont.appleMedium(size: 13.0)
    static let titleSpacing: CGFloat = -0.24
    static let titleColor = UIColor.black
    static let titleTopMargin: CGFloat = 10.0

    static let image = Assets.Image.PaperList.addCell
    static let buttonHeight: CGFloat = isPadDevice ? 119.0 : 134.0
}

private enum Text {
    static let title = "Add"
}

class PaperListAddCell: UICollectionViewCell {
    static let identifier = className

    // MARK: - UI Property
    private let titleLbel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(
            text: Text.title,
            font: Design.titleFont,
            align: .center,
            letterSpacing: Design.titleSpacing,
            foregroundColor: Design.titleColor
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension PaperListAddCell {

    func setupViews() {
        contentView.addSubview(addButton)
        contentView.addSubview(titleLbel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: Design.buttonHeight),

            titleLbel.topAnchor.constraint(equalTo: addButton.bottomAnchor,
                                           constant: Design.titleTopMargin),
            titleLbel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLbel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLbel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
