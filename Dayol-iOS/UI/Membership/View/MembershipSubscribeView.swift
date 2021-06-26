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
}

private enum Text {

}

class MembershipSubscribeView: UIView {
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setBackgroundColor(.brown, for: .normal)
        button.setTitle("첫 30일 무료체험 시작", for: .normal)
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

    private(set) var subscribeProductViews: [SubscribeProductView] = []

    var yearSubscribeProduct: SubscribeProductView? {
        return subscribeProductViews[safe: 0]
    }

    var monthSubscribeProduct: SubscribeProductView? {
        return subscribeProductViews[safe: 1]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.setZepplinShadow(x: 0, y: -2, blur: 4, color: UIColor(decimalRed: 0, green: 0, blue: 0, alpha: 0.1))
        self.addSubviews()
        self.addConstraints()
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

    func configure(_ products: [SubscribeProduct]) {
        products.forEach {
            let productContainer: SubscribeProductView = SubscribeProductView()
            productContainer.configure(with: $0)

            subscribeProductViews.append(productContainer)
            productsStackView.addArrangedSubview(productContainer)
        }

        yearSubscribeProduct?.selectHandler = { [weak self] view in
            view.isSelected = true
            self?.monthSubscribeProduct?.isSelected = !view.isSelected
        }

        monthSubscribeProduct?.selectHandler = {  [weak self] view in
            view.isSelected = true
            self?.yearSubscribeProduct?.isSelected = !view.isSelected
        }

        subscribeProductViews.first?.isSelected = true
    }
}
