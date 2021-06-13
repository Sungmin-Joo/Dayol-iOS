//
//  PaperSelectCollectionViewCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import UIKit

private enum Design {
    enum Title {
        static let titleFont = UIFont.appleMedium(size: 13)
        static let titleLetterSpace: CGFloat = -0.24
        static let titleFontColor = UIColor.black
    }

    enum Image {
        static let addImage = UIImage(named: "PaperSelectAdd")
    }

    enum Margin {
        static let titleImageSpace: CGFloat = 10
        static let verticalThumhailSize: CGSize = .init(width: 90, height: 134)
        static let horizontalThumhailSize: CGSize = .init(width: 90, height: 61)
    }
}

private enum Text {
    static let add = "Add"
}

final class MonthlyPaperListCollectionViewCell: UICollectionViewCell {
    private let paperImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center

        return imageView
    }()

    private let paperNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        contentView.addSubview(paperImageView)
        contentView.addSubview(paperNameLabel)

        NSLayoutConstraint.activate([
            paperImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            paperImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paperImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paperImageView.heightAnchor.constraint(equalToConstant: Design.Margin.verticalThumhailSize.height),

            paperNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paperNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paperNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureAddCell() {
        paperImageView.image = Design.Image.addImage
        paperNameLabel.attributedText = makeText(Text.add)
    }

    func configure(model: Paper) {
        let size = model.paperStyle == .vertical ? Design.Margin.verticalThumhailSize : Design.Margin.horizontalThumhailSize
        let thumbnailImage = UIImage(data: model.thumbnail ?? Data())?.resizeImage(targetSize: size)
        paperImageView.image = thumbnailImage
        paperNameLabel.attributedText = makeText(model.paperType.title)
    }

    private func makeText(_ text: String) -> NSAttributedString {
        return NSAttributedString.build(
            text: text,
            font: Design.Title.titleFont,
            align: .center,
            letterSpacing: Design.Title.titleLetterSpace,
            foregroundColor: Design.Title.titleFontColor
        )
    }
}
