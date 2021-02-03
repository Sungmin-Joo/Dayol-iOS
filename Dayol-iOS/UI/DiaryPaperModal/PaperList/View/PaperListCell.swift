//
//  PaperListCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/02.
//

import UIKit

private enum Design {

    static let titleFont = UIFont.appleMedium(size: 13.0)
    static let titleSpacing: CGFloat = -0.24
    static let titleColor = UIColor.black

    static let stackViewSpacing: CGFloat = 8.0
    static let stackViewTopMargin: CGFloat = 10.0

    static let chevronDownImage = Assets.Image.PaperList.chevronDown
    // TODO: - starredImage가 따로 등록이 안되어있어서 다른 곳에서 사용하는 동일한 이미지 사용했는데 사이즈가 안맞음, 수정 필요
    static let starredImage = Assets.Image.PaperList.starred

    static let starredButtonSize = CGSize(width: 23, height: 24)
    static let starredButtonInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 7)

    // TODO: - 가이드가 조금 애매해서 패드용 가로 썸네일 이미지 사이즈 수정 필요~
    static func imageSize(style: PaperModalModel.PaperOrientation) -> CGSize {
        switch style {
        case .landscape:
            return isPadDevice ? CGSize(width: 90, height: 58) : CGSize(width: 90, height: 80)
        case .portrait:
            return isPadDevice ? CGSize(width: 90, height: 119) : CGSize(width: 90, height: 134)
        }
    }
}

class PaperListCell: UICollectionViewCell {

    typealias ViewModel = PaperModalModel.PaperListCellModel

    static let identifier = className
    static var cellSize: CGSize {
        let height: CGFloat = isPadDevice ? 145.0 : 160.0
        return CGSize(width: 90.0, height: height)
    }

    var viewModel: ViewModel? {
        didSet {
            configure(viewModel)
        }
    }

    // MARK: - UI Property
    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Design.stackViewSpacing
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let titleLabel = UILabel()
    private let actionButton: UIButton = {
        let button = UIButton()
        let buttonWidth = Design.chevronDownImage?.size.width ?? .zero
        button.setImage(Design.chevronDownImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }()
    private let starredButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.starredImage, for: .normal)
        button.imageEdgeInsets = Design.starredButtonInset
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

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.removeConstraints(imageView.constraints)
    }

    func configure(_ viewModel: ViewModel?) {
        guard let viewModel = viewModel else { return }
        imageView.image = UIImage(named: viewModel.thumbnailName)
        titleLabel.attributedText = NSAttributedString.build(
            text: viewModel.title,
            font: Design.titleFont,
            align: .left,
            letterSpacing: Design.titleSpacing,
            foregroundColor: Design.titleColor
        )
        setImageViewConstraints(style: viewModel.orientation)
        starredButton.isHidden = viewModel.isStarred == false
    }
}

private extension PaperListCell {

    func setupViews() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(actionButton)
        imageView.addSubview(starredButton)
        imageContainerView.addSubview(imageView)

        contentView.addSubview(imageContainerView)
        contentView.addSubview(titleStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            starredButton.widthAnchor.constraint(equalToConstant: Design.starredButtonSize.width),
            starredButton.heightAnchor.constraint(equalToConstant: Design.starredButtonSize.height),

            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleStackView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor,
                                                constant: Design.stackViewTopMargin),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setImageViewConstraints(style: PaperModalModel.PaperOrientation) {
        let imageSize = Design.imageSize(style: style)

        NSLayoutConstraint.activate([
            starredButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            starredButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
    }

}
