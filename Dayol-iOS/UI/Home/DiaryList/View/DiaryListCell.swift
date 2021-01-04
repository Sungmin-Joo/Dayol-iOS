//
//  DiaryListCell.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import RxSwift

private enum Design {
    static let diaryCoverSize: DiaryType = .medium
    static let mainStackViewSpacing: CGFloat = 6.0
    static let titleStackViewSpacing: CGFloat = 5.0

    static let actionButton = Assets.Image.Home.diaryListActionButton

    static let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    static let titleColor = UIColor.black
    static let titleLetterSpacing: CGFloat = -0.33

    static let subTitleFont = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    static let subTitleColor = UIColor(decimalRed: 102, green: 102, blue: 102)
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
    // TODO: - 다이어리 리스트 편집 시 다이어리 커버 스케일 줄이는 애니메이션 자연스럽게
    var isEditMode = false {
        didSet {
            mainStackView.alpha = isEditMode ? 0 : 1
            diaryCoverView.alpha = isEditMode ? 0.5 : 1
            let scale: CGFloat = isEditMode ? 0.5 : 1.0
            contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    var viewModel: DiaryCoverModel? {
        didSet {
            configure()
        }
    }

    // MARK: - UI

    private(set) var diaryCoverView: DiaryView = {
        let coverView = DiaryView(type: Design.diaryCoverSize)
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

        diaryCoverView.setCover(color: viewModel.coverColor)
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            diaryCoverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            diaryCoverView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
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
