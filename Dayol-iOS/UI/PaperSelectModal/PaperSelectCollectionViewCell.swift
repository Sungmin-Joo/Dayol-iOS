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
    }
}

private enum Text {
    static let add = "Add"
}

final class PaperSelectCollectionViewCell: UICollectionViewCell {
    private let paperImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

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

            paperNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paperNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paperNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureAddCell() {
        paperImageView.image = Design.Image.addImage
        paperNameLabel.attributedText = makeText(Text.add)
    }

    func configure(model: DiaryInnerModel.PaperModel) {
        paperImageView.image = makePaperThumbnail(model)
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

    private func makePaperThumbnail(_ model: DiaryInnerModel.PaperModel) -> UIImage? {
        let paperPresentView = PaperPresentView(paper: model, flexibleSize: true)
        let style = model.paperStyle

        let size: CGSize
        switch style {
        case .horizontal:
            size = CGSize(width: 90, height: 61)
        case .vertical:
            size = CGSize(width: 90, height: 134)
        }

        paperPresentView.frame.size = size
        paperPresentView.layoutIfNeeded()

        print(paperPresentView.asImage())
        return paperPresentView.asImage()
    }
}
