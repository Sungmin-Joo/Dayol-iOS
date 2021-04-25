//
//  InfoView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/01.
//

import UIKit

private enum Design {
    static let spacing: CGFloat = 10.0
    static let stackViewInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    static let stackViewHeight: CGFloat = 56.0

    static let infoImage = Assets.Image.InfoView.info
    static let closeImage = Assets.Image.InfoView.close

    static let numberOfLines = 2
    static let textColor = UIColor.gray800
    static let letterSpacing: CGFloat = -0.26
    static let font = UIFont.appleMedium(size: 14.0)

    static let backGroundColor = UIColor.gray300
}

class InfoView: UIView {

    // MARK: UI

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Design.spacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let spacingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Design.spacing),
            view.heightAnchor.constraint(equalToConstant: Design.spacing)
        ])
        return view
    }()
    private let infoImageView: UIImageView = {
        let imageView = UIImageView(image: Design.infoImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let imageSize = imageView.image?.size ?? .zero
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
        return imageView
    }()
    private(set) var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.closeImage, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false

        let imageSize = Design.closeImage?.size ?? .zero

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: imageSize.width),
            button.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
        return button
    }()
    private let infoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.numberOfLines
        return label
    }()

    // MARK: Init
    
    init(text: String) {
        super.init(frame: .zero)
        setViews()
        setConstraints()
        setText(text)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

private extension InfoView {

    func setViews() {
        stackView.addArrangedSubview(infoImageView)
        stackView.addArrangedSubview(infoTextLabel)
        stackView.addArrangedSubview(spacingView)
        stackView.addArrangedSubview(closeButton)
        addSubview(stackView)
        backgroundColor = Design.backGroundColor
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: Design.stackViewInset.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -Design.stackViewInset.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: Design.stackViewHeight)
        ])
    }

    func setText(_ text: String) {
        let attributedText = NSAttributedString.build(text: text,
                                                      font: Design.font,
                                                      align: .left,
                                                      letterSpacing: Design.letterSpacing,
                                                      foregroundColor: Design.textColor)
        infoTextLabel.attributedText = attributedText
    }

}
