//
//  File.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/23.
//

import UIKit

struct SubscribeProduct {
    let title: String
    let price: String
    let description: String

    let emphasisTitleStrings: [String]
}

private enum Design {
    case normal, selected
    var containerRadius: CGFloat { 8 }
    var containerBorderWidth: CGFloat {
        switch self {
        case .normal: return 1
        case .selected: return 2
        }
    }
    var containerBorderColor: CGColor {
        switch self {
        case .normal: return UIColor.gray500.cgColor
        case .selected: return UIColor.dayolBrown.cgColor
        }
    }

    static let titleColor: UIColor = .init(red: 34, green: 34, blue: 34, alpha: 0)
    static let titleFont: UIFont = .systemFont(ofSize: 15, weight: .regular)
    static let emphasisTitleFont: UIFont = .systemFont(ofSize: 15, weight: .bold)

    static let priceColor: UIColor = .dayolBrown
    static let priceFont: UIFont = .systemFont(ofSize: 17, weight: .bold)

    static let descriptionColor: UIColor = .gray800
    static let descriptionFont: UIFont = .systemFont(ofSize: 13, weight: .bold)

    static func selectBoxImage(isOn: Bool) -> UIImage? {
        if isOn {
            return UIImage(named: "btnCheckOn")
        } else {
            return UIImage(named: "btnCheckOff")
        }
    }
}

class SubscribeProductView: UIView {
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black//Design.titleColor
        label.font = Design.titleFont
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Design.priceColor
        label.font = Design.priceFont
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Design.descriptionColor
        label.font = Design.descriptionFont
        return label
    }()

    private let selectBox: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.selectBoxImage(isOn: false), for: .normal)
        return button
    }()

    private let labelContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private var design: Design {
        return isSelected ? .selected : .normal
    }

    var isSelected: Bool = false {
        didSet {
            updateViewIfNeeded()
        }
    }

    var selectHandler: ((SubscribeProductView) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = design.containerRadius
        layer.borderWidth = design.containerBorderWidth
        layer.borderColor = design.containerBorderColor
        layer.masksToBounds = true

        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addSubviews() {
        labelContainer.addArrangedSubview(productTitleLabel)
        labelContainer.addArrangedSubview(priceLabel)
        labelContainer.addArrangedSubview(descriptionLabel)
        self.addSubview(labelContainer)
        self.addSubview(selectBox)
        selectBox.addTarget(self, action: #selector(didTapSelectBox), for: .touchUpInside)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            labelContainer.centerYAnchor.constraint(equalTo: centerYAnchor),

            selectBox.widthAnchor.constraint(equalToConstant: 24),
            selectBox.heightAnchor.constraint(equalToConstant: 24),
            selectBox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            selectBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    private func updateViewIfNeeded() {
        layer.borderWidth = design.containerBorderWidth
        layer.borderColor = design.containerBorderColor

        selectBox.setImage(Design.selectBoxImage(isOn: isSelected), for: .normal)
    }

    func configure(with model: SubscribeProduct) {
        productTitleLabel.text = model.title
        productTitleLabel.adjustPartialStringFont(model.emphasisTitleStrings, partFont: Design.emphasisTitleFont)

        priceLabel.text = model.price

        descriptionLabel.text = model.description
    }
}

// MARK: - Action

private extension SubscribeProductView {
    @objc func didTapSelectBox() {
        if !isSelected {
            selectHandler?(self)
        }
    }
}
