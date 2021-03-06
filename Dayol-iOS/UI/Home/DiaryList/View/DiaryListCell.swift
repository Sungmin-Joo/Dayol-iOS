//
//  DiaryListCell.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import UIKit
import RxSwift

private enum Design {
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
        static let `default` = CGSize(width: 278, height: 432)
        static let edit = CGSize(width: 139, height: 216)
    }

    private let disposeBag = DisposeBag()
    private var diaryHeight: CGFloat {
        if isEditMode {
            return 180.0
        }
        return 360.0
    }
    private var diaryViewHeightConstraint: NSLayoutConstraint?
    // TODO: - 다이어리 리스트 편집 시 다이어리 커버 스케일 줄이는 애니메이션 자연스럽게
    var isEditMode = false {
        didSet {
            mainStackView.alpha = isEditMode ? 0 : 1
            diaryCoverView.alpha = isEditMode ? 0.5 : 1
            self.diaryViewHeightConstraint?.constant = diaryHeight
        }
    }

    var viewModel: DiaryInfoModel? {
        didSet {
            configure()
        }
    }

    // MARK: - UI

    private(set) var diaryCoverView: DiaryView = {
        let coverView = DiaryView()
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
        let subTitle = "\(viewModel.totalPage)page"
        let coverColor: DiaryCoverColor = DiaryCoverColor.find(hex: viewModel.colorHex) ?? .DYBrown

        diaryCoverView.setCover(color: coverColor)
        titleLabel.attributedText = Design.attributedTitle(text: viewModel.title)
        subTitleLabel.attributedText = Design.attributedSubTitle(text: subTitle)

        if let password = viewModel.password {
            // 패스워드가 있는 경우!
            diaryCoverView.isLock = true
        } else {
            diaryCoverView.isLock = false
        }

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
    }

    private func setupConstraints() {
        let diaryViewHeightConstraint = diaryCoverView.heightAnchor.constraint(equalToConstant: diaryHeight)
        NSLayoutConstraint.activate([
            diaryCoverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            diaryCoverView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            diaryCoverView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            diaryViewHeightConstraint,

            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        self.diaryViewHeightConstraint = diaryViewHeightConstraint
    }
}

// MARK: - Bind

extension DiaryListCell {

    private func bind() {
        actionButton.rx.tap.subscribe(onNext: {
            // TODO: - action sheet
            debugPrint("TODO: - action sheet")
        })
        .disposed(by: disposeBag)
    }

}
