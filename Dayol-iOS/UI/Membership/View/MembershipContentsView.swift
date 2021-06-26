//
//  MembershipHeaderView.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/20.
//

import UIKit

private enum Design {
    enum Image {
        static func contents(with type: UserActivityType) -> [UIImage?] {
            switch type {
            case .new:
                return [
                    UIImage(namedByLanguage: "imgMembership_new")
                ]
            case .comeback:
                return [
                    UIImage(namedByLanguage: "imgMembership_comeback")
                ]
            case .exist:
                return [
                    UIImage(namedByLanguage: "imgMembership_exist_header"),
                    UIImage(namedByLanguage: "imgMembership_exist_body")
                ]
            }
        }
    }
}

private enum Text {
}

class MembershipContentsView: UIView {
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private let type: UserActivityType

    required init(_ viewModel: MembershipViewController.ViewModel) {
        self.type = viewModel.userActivityType
        super.init(frame: .zero)
        self.addSubviews()
        self.addConstraints()
        self.configure()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func addSubviews() {
        addSubview(containerStackView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure() {
        if type == .exist {
            let headerImage = Design.Image.contents(with: type)[safe: 0] ?? UIImage()
            let bodyImage = Design.Image.contents(with: type)[safe: 1] ?? UIImage()

            let headerImageView = makeImageView(with: headerImage)
            let expirationDateView = makeExpirationDateView(with: Date.now) // TODO: 실제 구독날자로 변경해야됨.
            let bodyImageView = makeImageView(with: bodyImage)

            containerStackView.addArrangedSubview(headerImageView)
            containerStackView.addArrangedSubview(expirationDateView)
            containerStackView.addArrangedSubview(bodyImageView)

            containerStackView.setCustomSpacing(30, after: headerImageView)
            containerStackView.setCustomSpacing(35, after: expirationDateView)
        } else {
            let image = Design.Image.contents(with: type).first ?? UIImage()
            let imageView = makeImageView(with: image)
            containerStackView.addArrangedSubview(imageView)
        }
    }

    private func makeImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }

    private func makeExpirationDateView(with date: Date) -> UIView {
        let outView = UIView()
        outView.translatesAutoresizingMaskIntoConstraints = false
        outView.backgroundColor = .clear

        let inView = UIView()
        inView.translatesAutoresizingMaskIntoConstraints = false
        inView.backgroundColor = .gray100
        inView.layer.cornerRadius = 10
        inView.layer.masksToBounds = true

        outView.addSubview(inView)

        NSLayoutConstraint.activate([
            outView.heightAnchor.constraint(equalToConstant: 60),

            inView.topAnchor.constraint(equalTo: outView.topAnchor),
            inView.bottomAnchor.constraint(equalTo: outView.bottomAnchor),
            inView.leadingAnchor.constraint(equalTo: outView.leadingAnchor, constant: 20),
            inView.trailingAnchor.constraint(equalTo: outView.trailingAnchor, constant: -20)
        ])

        return outView
    }
}

