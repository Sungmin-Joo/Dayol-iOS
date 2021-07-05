//
//  MembershipSubscribeView.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/21.
//

import UIKit
import RxCocoa

private enum Design {
    static let productsMargin: UIEdgeInsets = .init(top: 20, left: 18, bottom: -16, right: -18)
    static let subscribeButtonHeight: CGFloat = 68

    static let buttonBackgroundColor: UIColor = .dayolBrown
    static let buttonTitleColor: UIColor = .white
    static let buttonTitleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
    static let buttonDescriptionFont: UIFont = .systemFont(ofSize: 13, weight: .medium)
}

protocol MembershipSubscribeViewDelegate: AnyObject {
    func didTapSubscribe(productView: SubscribeProductView)
}

class MembershipSubscribeView: UIView {
    weak var delegate: MembershipSubscribeViewDelegate?

    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = Design.buttonTitleColor
        button.titleLabel?.font = Design.buttonTitleFont
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.addLetterSpacing(-0.3)
        button.setBackgroundColor(Design.buttonBackgroundColor, for: .normal)
        return button
    }()

    private let productsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()

    private(set) var yearSubscribeProductView: SubscribeProductView?
    private(set) var monthSubscribeProductView: SubscribeProductView?

    private var userActivityType: UserActivityType = .new

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.setZepplinShadow(x: 0, y: -2, blur: 4, color: UIColor(decimalRed: 0, green: 0, blue: 0, alpha: 0.1))

        self.addSubviews()
        self.addConstraints()

        subscribeButton.addTarget(self, action: #selector(didTapSubscribeButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        addSubview(productsStackView)
        addSubview(subscribeButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            productsStackView.topAnchor.constraint(equalTo: topAnchor, constant: Design.productsMargin.top),
            productsStackView.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: Design.productsMargin.bottom),
            productsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.productsMargin.left),
            productsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Design.productsMargin.right),

            subscribeButton.heightAnchor.constraint(equalToConstant: Design.subscribeButtonHeight),
            subscribeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            subscribeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            subscribeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(_ types: [SubscribeItemType], for userActivityType: UserActivityType) {
        self.userActivityType = userActivityType
        let productTypes = types.sorted(by: { $0.order < $1.order })
        productTypes.forEach {
            let productView = SubscribeProductView()
            switch $0 {
            case .year:
                productView.configure(with: $0)

                productsStackView.addArrangedSubview(productView)
                yearSubscribeProductView = productView
                yearSubscribeProductView?.isSelected = true
                updateSubscribeButton($0)
            case .month:
                productView.configure(with: $0)

                productsStackView.addArrangedSubview(productView)
                monthSubscribeProductView = productView
                monthSubscribeProductView?.isSelected = false
            }
        }

        bindSelectHandler()
    }

    private func bindSelectHandler() {
        yearSubscribeProductView?.selectHandler = { [weak self] view in
            view.isSelected = true

            if let type = view.type {
                self?.updateSubscribeButton(type)
            }
            if let otherProductView = self?.monthSubscribeProductView {
                otherProductView.isSelected = !view.isSelected
            }
        }

        monthSubscribeProductView?.selectHandler = {  [weak self] view in
            view.isSelected = true

            if let type = view.type {
                self?.updateSubscribeButton(type)
            }
            if let otherProductView = self?.yearSubscribeProductView {
                otherProductView.isSelected = !view.isSelected
            }
        }
    }

    private func updateSubscribeButton(_ type: SubscribeItemType) {
        let title: String = type.buttonTitle(with: userActivityType) + type.buttonDescription(with: userActivityType)
        let description: String = type.buttonDescription(with: userActivityType)

        self.subscribeButton.setTitle(title, for: .normal)
        self.subscribeButton.titleLabel?.adjustPartialStringFont([description], partFont: Design.buttonDescriptionFont)
    }
}

// MARK: - Action

private extension MembershipSubscribeView {
    @objc func didTapSubscribeButton() {
        if let productView = yearSubscribeProductView, productView.isSelected {
            delegate?.didTapSubscribe(productView: productView)
        } else if let productView = monthSubscribeProductView, productView.isSelected {
            delegate?.didTapSubscribe(productView: productView)
        } else {
            return
        }
    }
}
