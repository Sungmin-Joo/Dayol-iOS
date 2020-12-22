//
//  DiaryListCell.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import RxSwift

private enum Design {
    static let diaryCoverSize = CGSize(width: 278, height: 360)
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

    private let disposeBag = DisposeBag()
    var viewModel: DiaryCoverModel? {
        didSet {
            configure()
        }
    }

    // MARK: - UI

    private let diaryCoverView: UIView = {
        let coverView = UIView(frame: .zero)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        return coverView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = Design.mainStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.spacing = Design.titleStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
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
    }

    // MARK: - Bind ViewModel

    private func configure() {
        guard let viewModel = viewModel else { return }
        let subTitle = "\(viewModel.totalPage)page"

        // TODO: - 다이어리 커버 뷰 작업
        diaryCoverView.backgroundColor = viewModel.coverColor
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
            diaryCoverView.topAnchor.constraint(equalTo: topAnchor),
            diaryCoverView.heightAnchor.constraint(equalToConstant: Design.diaryCoverSize.height),
            diaryCoverView.widthAnchor.constraint(equalToConstant: Design.diaryCoverSize.width),
            diaryCoverView.centerXAnchor.constraint(equalTo: centerXAnchor),

            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
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
