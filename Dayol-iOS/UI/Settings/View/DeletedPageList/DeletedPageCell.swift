//
//  DeletedPageCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/14.
//

import UIKit

private enum Design {
    static let titleAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: textParagraphStyle(lineHeight: 19.0),
        .font: UIFont.appleBold(size: 15.0),
        .foregroundColor: UIColor(decimalRed: 34, green: 34, blue: 34),
        .kern: -0.28
    ]
    static let diaryNameAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: textParagraphStyle(lineHeight: 17.0),
        .font: UIFont.appleRegular(size: 14.0),
        .foregroundColor: UIColor(decimalRed: 102, green: 102, blue: 102),
        .kern: -0.26
    ]
    static let dateAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: textParagraphStyle(lineHeight: 17.0),
        .font: UIFont.systemFont(ofSize: 14.0),
        .foregroundColor: UIColor(decimalRed: 153, green: 153, blue: 153),
        .kern: -0.26
    ]
    static func textParagraphStyle(lineHeight: CGFloat) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        return paragraphStyle
    }

    static let titleLabelTopMargin: CGFloat = 16.0
    static let diaryNameLabelTopMargin: CGFloat = 2.0
    static let dateLabelTopMargin: CGFloat = 4.0
}

private enum Text {
    static let dateSuffix = "삭제됨"
}

class DeletedPageCell: UICollectionViewCell {
    static let identifier = className
    static var cellSize = CGSize(width: 140.0, height: 284.0)
    var viewModel: DeletedPageCellModel? {
        didSet {
            configure(viewModel)
        }
    }
    

    // MARK: UI Property

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.setZepplinShadow(x: 0,
                                         y: 6,
                                         blur: 12,
                                         color: UIColor.black.withAlphaComponent(0.1))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let diaryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension DeletedPageCell {

    func setupViews() {
        // TODO: test code 제거
        thumbnailImageView.backgroundColor = UIColor.white

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(diaryNameLabel)
        contentView.addSubview(dateLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor,
                                            constant: Design.titleLabelTopMargin),

            diaryNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            diaryNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                constant: Design.diaryNameLabelTopMargin),

            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: diaryNameLabel.bottomAnchor,
                                           constant: Design.dateLabelTopMargin),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(_ viewModel: DeletedPageCellModel?) {
        guard let viewModel = viewModel else { return }
        thumbnailImageView.image = UIImage(named: viewModel.thumbnailImageName)
        titleLabel.attributedText = NSAttributedString(string: viewModel.title,
                                                       attributes: Design.titleAttributes)
        let diaryName = "(\(viewModel.diaryName))"
        diaryNameLabel.attributedText = NSAttributedString(string: diaryName,
                                                           attributes: Design.diaryNameAttributes)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.dd " + Text.dateSuffix
        let dateStirng = dateFormatter.string(from: viewModel.deletedDate)

        dateLabel.attributedText = NSAttributedString(string: dateStirng,
                                                      attributes: Design.dateAttributes)
    }

}
