//
//  OutAppSettingCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/08.
//

import UIKit

private enum Design {
    static let chevronImage = Assets.Image.Settings.chevron
    static let chevronImageWidth: CGFloat = 6.0
    
    static let stackViewInset = UIEdgeInsets(top: 17, left: 20, bottom: 16, right: 24)
    static let stackViewSpacing: CGFloat = 12.0

    static let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.appleBold(size: 17.0),
        .kern: -0.31,
        .foregroundColor: UIColor.black
    ]
}

class OutAppSettingCell: UITableViewCell, SettingCellPresentable {
    typealias ViewModel = SettingModel.OutApp.CellModel
    static let identifier = className

    var viewModel: SettingCellModelProtocol? = nil {
        didSet {
            configuration(viewModel)
        }
    }

    // MARK: - UI
    private let titleLabel = UILabel()
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
    }

    func configuration(_ viewModel: SettingCellModelProtocol?) {
        guard let viewModel = viewModel as? ViewModel else { return }
        titleLabel.attributedText = NSMutableAttributedString(string: viewModel.title,
                                                              attributes: Design.titleAttributes)
    }

}

extension OutAppSettingCell {
    private func setupViews() {
        chevronImageView.image = Design.chevronImage
        chevronImageView.sizeToFit()

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(chevronImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: Design.stackViewInset.top),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Design.stackViewInset.left),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Design.stackViewInset.right),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -Design.stackViewInset.bottom),
            chevronImageView.widthAnchor.constraint(equalToConstant: Design.chevronImageWidth)
        ])
    }
}
