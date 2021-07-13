//
//  OnboadingContentView.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/19.
//

import UIKit

class OnboardingContentView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 38
        return stackView
    }()

    init(image: UIImage?, description: String, optionStrings: [String]) {
        super.init(frame: .zero)
        imageView.image = image
        descriptionLabel.text = description
        descriptionLabel.addLetterSpacing(-0.33)
        descriptionLabel.adjustPartialStringFont(optionStrings, partFont: UIFont.systemFont(ofSize: 18, weight: .bold))

        configureView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureView() {
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(descriptionLabel)
        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 315),
            imageView.heightAnchor.constraint(equalToConstant: 250),

            descriptionLabel.widthAnchor.constraint(equalToConstant: 315),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 81),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

}
