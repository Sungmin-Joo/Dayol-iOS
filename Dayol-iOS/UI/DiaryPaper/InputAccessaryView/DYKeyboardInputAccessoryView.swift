//
//  DYKeyboardInputAccessoryView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/22.
//

import UIKit

private enum Design {
    static let defaultTextColor = UIColor.black
    static let backgroundColor = UIColor.white
    static let horizontalSeparatorColor = UIColor.gray400
    static let verticalSeparatorColor = UIColor(decimalRed: 225, green: 225, blue: 225)

    static let textColorButtonRadius: CGFloat = 13.5
    static let textColorButtonDiameter: CGFloat = 27.0
    static let textColorButtonRightMargin: CGFloat = 14.0

    static let stackViewSpacing: CGFloat = 8.0
    static let stackViewHeight: CGFloat = 36.0
    static let stackViewInset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 0)

    static let checkImage = UIImage(named: "keyboard_accessory_checkbox")
    static let bulletImage = UIImage(named: "keyboard_accessory_bullet")
    static let textStyleImage = UIImage(named: "keyboard_accessory_textstyle")
    static let keyboardImage = UIImage(named: "keyboard_accessory_keyboarddown")

}

class DYKeyboardInputAccessoryView: UIView {

    private(set) var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.checkImage, for: .normal)
        button.adjustsImageWhenHighlighted = true
        return button
    }()
    private(set) var bulletButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.bulletImage, for: .normal)
        return button
    }()
    private(set) var textStyleButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.textStyleImage, for: .normal)
        return button
    }()
    private let verticalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = Design.verticalSeparatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private(set) var textColorButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Design.textColorButtonRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private(set) var keyboardDownButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.keyboardImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = Design.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private(set) var currentColor: UIColor {
        didSet {
            updateCurrentTextColor()
        }
    }

    init(currentColor: UIColor = Design.defaultTextColor) {
        self.currentColor = currentColor
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        setupViews()
        setupConstraints()
        setupHorizontalSeparator()
        updateCurrentTextColor()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

private extension DYKeyboardInputAccessoryView {

    func updateCurrentTextColor() {
        textColorButton.backgroundColor = currentColor
    }

    func setupViews() {
        leftStackView.addArrangedSubview(checkButton)
        leftStackView.addArrangedSubview(bulletButton)
        leftStackView.addArrangedSubview(textStyleButton)
        addSubview(leftStackView)
        addSubview(textColorButton)
        addSubview(verticalSeparator)
        addSubview(keyboardDownButton)
        backgroundColor = Design.backgroundColor
    }

    func setupConstraints() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: Design.stackViewInset.left),
            leftStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                               constant: Design.stackViewInset.top),
            leftStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -Design.stackViewInset.bottom),

            keyboardDownButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            keyboardDownButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            keyboardDownButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            verticalSeparator.topAnchor.constraint(equalTo: safeArea.topAnchor),
            verticalSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalSeparator.trailingAnchor.constraint(equalTo: keyboardDownButton.leadingAnchor),
            verticalSeparator.widthAnchor.constraint(equalToConstant: 1.0),

            textColorButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            textColorButton.widthAnchor.constraint(equalToConstant: Design.textColorButtonDiameter),
            textColorButton.heightAnchor.constraint(equalToConstant: Design.textColorButtonDiameter),
            textColorButton.trailingAnchor.constraint(equalTo: verticalSeparator.leadingAnchor,
                                                      constant: -Design.textColorButtonRightMargin),

        ])
    }

    func setupHorizontalSeparator() {
        let upperSeparator = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: bounds.width,
                                                  height: 1))
        upperSeparator.backgroundColor = Design.horizontalSeparatorColor
        upperSeparator.autoresizingMask = [.flexibleWidth]
        addSubview(upperSeparator)

        let lowerSeparator = UIView(frame: CGRect(x: 0,
                                                  y: bounds.height - 1,
                                                  width: bounds.width,
                                                  height: 1))
        lowerSeparator.backgroundColor = Design.horizontalSeparatorColor
        lowerSeparator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lowerSeparator)
    }

}
