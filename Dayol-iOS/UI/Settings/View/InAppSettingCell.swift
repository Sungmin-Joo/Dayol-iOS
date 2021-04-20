//
//  SettingsRowCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/07.
//

import UIKit

private enum Design {
    static let chevronImage = Assets.Image.Settings.chevron
    static let chevronImageWidth: CGFloat = 6.0

    static let mainStackViewInset = UIEdgeInsets(top: 17, left: 20, bottom: 16, right: 24)
    static let contentsStackViewSpacing: CGFloat = 12.0
    static let spacingViewSize = CGSize(width: 20, height: 20)

    static let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.appleBold(size: 17.0),
        .kern: -0.31,
        .foregroundColor: UIColor.black
    ]

    static let subtitleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.appleMedium(size: 14.0),
        .kern: -0.26,
        .foregroundColor: UIColor.gray800
    ]
}

class InAppSettingCell: UITableViewCell, SettingCellPresentable {
    typealias ViewModel = SettingModel.InApp.CellModel
    static let identifier = className

    var viewModel: SettingCellModelProtocol? = nil {
        didSet {
            configuration(viewModel)
        }
    }

    // MARK: - UI

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let chevronImageView = UIImageView()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = .none
        subtitleLabel.text = .none
        iconImageView.image = .none
    }

    func configuration(_ viewModel: SettingCellModelProtocol?) {
        guard let viewModel = viewModel as? ViewModel else { return }

        titleLabel.attributedText = NSMutableAttributedString(string: viewModel.title,
                                                              attributes: Design.titleAttributes)
        subtitleLabel.attributedText = NSMutableAttributedString(string: viewModel.subTitle,
                                                                 attributes: Design.subtitleAttributes)
        iconImageView.image = UIImage(named: viewModel.iconImageName)

    }
}

extension InAppSettingCell {

    private func setupViews() {
        setupMainStackView()
        setupContentsStackView()
    }

    private func setupMainStackView() {
        chevronImageView.image = Design.chevronImage
        mainStackView.addArrangedSubview(contentsStackView)
        mainStackView.addArrangedSubview(chevronImageView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Design.mainStackViewInset.top),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Design.mainStackViewInset.left),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Design.mainStackViewInset.right),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -Design.mainStackViewInset.bottom),
            chevronImageView.widthAnchor.constraint(equalToConstant: Design.chevronImageWidth)
        ])
    }

    private func setupContentsStackView() {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.spacing = Design.contentsStackViewSpacing

        titleStackView.addArrangedSubview(iconImageView)
        titleStackView.addArrangedSubview(titleLabel)

        let spacingView = UIView(frame: .zero)
        spacingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spacingView.widthAnchor.constraint(equalToConstant: Design.spacingViewSize.width),
            spacingView.heightAnchor.constraint(equalToConstant: Design.spacingViewSize.height)
        ])

        let subtitleStackView = UIStackView()
        subtitleStackView.axis = .horizontal
        subtitleStackView.spacing = Design.contentsStackViewSpacing

        subtitleStackView.addArrangedSubview(spacingView)
        subtitleStackView.addArrangedSubview(subtitleLabel)

        contentsStackView.addArrangedSubview(titleStackView)
        contentsStackView.addArrangedSubview(subtitleStackView)
    }

}
