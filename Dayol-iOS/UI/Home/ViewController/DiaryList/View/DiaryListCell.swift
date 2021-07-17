//
//  DiaryListCell.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import UIKit
import RxSwift

private enum Design {
    static let shadowColor: UIColor = UIColor.black.withAlphaComponent(0.2)

    static let mainStackViewTopMargin: CGFloat = 30.0
    static let mainStackViewSpacing: CGFloat = 6.0
    static let titleStackViewSpacing: CGFloat = 5.0

    static let actionButton = Assets.Image.Home.diaryListActionButton

    static let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    static let titleColor = UIColor.black
    static let titleLetterSpacing: CGFloat = -0.33

    static let subTitleFont = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    static let subTitleColor = UIColor.gray800
    static let subTitleLetterSpacing: CGFloat = -0.26

    static func attributedTitle(text: String) -> NSAttributedString {
        return NSMutableAttributedString.build(text: text,
                                               font: titleFont,
                                               align: .center,
                                               letterSpacing: titleLetterSpacing,
                                               foregroundColor: titleColor)
    }
    static func attributedSubTitle(text: String) -> NSAttributedString {
        return NSMutableAttributedString.build(text: text,
                                               font: subTitleFont,
                                               align: .center,
                                               letterSpacing: subTitleLetterSpacing,
                                               foregroundColor: subTitleColor)
    }
}

class DiaryListCell: UICollectionViewCell {
    static let identifier = "\(DiaryListCell.self)"
    enum Size {
        static let defaultSize = CGSize(width: 278, height: 432)
        static var normal: CGSize {
            if UIScreen.main.bounds.size.height <= 667 {
                return CGSize(width: defaultSize.width * 0.7, height: defaultSize.height * 0.7)
            }
            return defaultSize
        }
        static var edit: CGSize {
            return CGSize(width: defaultSize.width * 0.5, height: defaultSize.height * 0.5)
        }
    }

    private let disposeBag = DisposeBag()
    private var diaryHeight: CGFloat {
        if isEditMode {
            return 180.0
        }
        return 360.0
    }

    var isEditMode = false {
        didSet {
            mainStackView.alpha = isEditMode ? 0 : 1
            diaryCoverView.alpha = isEditMode ? 0.5 : 1
        }
    }
    var didTapModeMenuButton: (() -> Void)?
    var viewModel: Diary? {
        didSet {
            configure()
        }
    }

    // MARK: - UI

    private(set) var diaryCoverView: UIImageView = {
        let coverView = UIImageView()
        coverView.translatesAutoresizingMaskIntoConstraints = false
        return coverView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Design.mainStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Design.titleStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Design.actionButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        bind()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()

        diaryCoverView.backgroundColor = .none
        titleLabel.attributedText = .none
        subTitleLabel.attributedText = .none
        isEditMode = false
    }

    // MARK: - Bind ViewModel

    private func configure() {
        guard let viewModel = viewModel else { return }
        // TODO: - 속지 갯수 패치
//        let subTitle = "\(viewModel.paperCount)page"
        let subTitle = "0page"

        diaryCoverView.image = UIImage(data: viewModel.thumbnail)
        titleLabel.attributedText = Design.attributedTitle(text: viewModel.title)
        subTitleLabel.attributedText = Design.attributedSubTitle(text: subTitle)
    }
    
}

// MARK: - Setup

extension DiaryListCell {

    private func setupViews() {
        contentView.addSubview(diaryCoverView)
        contentView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(subTitleLabel)

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(actionButton)

        layer.setZepplinShadow(x: 0, y: 6, blur: 12, color: Design.shadowColor)
    }

    private func setupConstraints() {
        let thumbnailSize = diaryCoverView.image?.size ?? CGSize(width: 278, height: 360)
        let thumbailRatio = thumbnailSize.width / thumbnailSize.height

        NSLayoutConstraint.activate([
            diaryCoverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            diaryCoverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            diaryCoverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            diaryCoverView.widthAnchor.constraint(equalTo: diaryCoverView.heightAnchor,
                                                  multiplier: thumbailRatio),

            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: - Bind

extension DiaryListCell {

    private func bind() {
        actionButton.rx.tap.bind { [weak self] in
            self?.didTapModeMenuButton?()
        }
        .disposed(by: disposeBag)
    }

}
