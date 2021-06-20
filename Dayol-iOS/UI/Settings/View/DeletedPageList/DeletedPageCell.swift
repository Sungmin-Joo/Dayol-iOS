//
//  DeletedPageCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/14.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let titleAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: textParagraphStyle(lineHeight: 19.0),
        .font: UIFont.appleBold(size: 15.0),
        .foregroundColor: UIColor.gray900,
        .kern: -0.28
    ]
    static let subTitleAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: textParagraphStyle(lineHeight: 17.0),
        .font: UIFont.appleRegular(size: 14.0),
        .foregroundColor: UIColor.gray800,
        .kern: -0.26
    ]
    static let dateAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: textParagraphStyle(lineHeight: 17.0),
        .font: UIFont.systemFont(ofSize: 14.0),
        .foregroundColor: UIColor.gray700,
        .kern: -0.26
    ]
    static func textParagraphStyle(lineHeight: CGFloat) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        return paragraphStyle
    }

    static let infoStackViewTopMargin: CGFloat = 18.0
    static let infoStackViewSpacing: CGFloat = 2.0

    static let diaryNameLabelTopMargin: CGFloat = 2.0
    static let dateLabelTopMargin: CGFloat = 4.0
    static let detailButtonImage = Assets.Image.Settings.detail
}

private enum Text {
    static let dateSuffix = "삭제됨"
}

class DeletedPageCell: UICollectionViewCell {
    static let identifier = className
    static var cellSize = CGSize(width: 150.0, height: 265.0)

    private let disposeBag = DisposeBag()
    var didTapModeMenuButtonWithDiaryId: ((String) -> Void)?
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
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.detailButtonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Design.infoStackViewSpacing
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()


    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension DeletedPageCell {

    func setupViews() {
        // TODO: test code 제거
        thumbnailImageView.backgroundColor = UIColor.white

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(detailButton)

        infoStackView.addArrangedSubview(titleStackView)
        infoStackView.addArrangedSubview(subTitleLabel)
        infoStackView.addArrangedSubview(dateLabel)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(infoStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            thumbnailImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            infoStackView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor,
                                               constant: Design.infoStackViewTopMargin),
            infoStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            infoStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }

    func bindEvent(){
        detailButton.rx.tap.bind { [weak self] in
            guard let self = self, let viewModel = self.viewModel else { return }
            self.didTapModeMenuButtonWithDiaryId?(viewModel.id)
        }
        .disposed(by: disposeBag)
    }

    func configure(_ viewModel: DeletedPageCellModel?) {
        guard let viewModel = viewModel else { return }
        thumbnailImageView.image = UIImage(data: viewModel.thumbnail)
        titleLabel.attributedText = NSAttributedString(string: viewModel.title,
                                                       attributes: Design.titleAttributes)
        let diaryName = "(\(viewModel.subTitle))"
        subTitleLabel.attributedText = NSAttributedString(string: diaryName,
                                                          attributes: Design.subTitleAttributes)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.dd " + Text.dateSuffix
        let dateStirng = dateFormatter.string(from: viewModel.deletedDate)

        dateLabel.attributedText = NSAttributedString(string: dateStirng,
                                                      attributes: Design.dateAttributes)
    }

}
