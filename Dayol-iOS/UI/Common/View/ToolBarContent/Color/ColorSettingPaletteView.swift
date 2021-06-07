//
//  ColorSettingPaletteView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/18.
//

import UIKit
import Combine

private enum Design {
    static let currentColorViewRadius: CGFloat = 18.0
    static let currentColorViewDiameter: CGFloat = 36.0
    static let currentColorBorderWidth: CGFloat = 1.0
    static let currentColorBorderColor: UIColor = .gray200

    static let contentStackViewSpacing: CGFloat = 16.0
    static let contentSideMargin: CGFloat = 20.0

    static let separatorColor = UIColor(decimalRed: 200, green: 202, blue: 204)
    static let separatorWidth: CGFloat = 1
    static let separatorHeight: CGFloat = 24

    static let plusButtonImage = Assets.Image.ToolBar.ColorPicker.plus
}

class ColorSettingPaletteView: UIView {

    let colorSubject = PassthroughSubject<UIColor, Never>()
    private var colors: [DYPaletteColor] {
        return DYPaletteColor.penColorPreset
    }

    // MARK: UI Property

    private let currentColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Design.currentColorViewRadius
        view.layer.borderWidth = Design.currentColorBorderWidth
        view.layer.borderColor = Design.currentColorBorderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let palleteView: DYColorPaletteView = {
        let view = DYColorPaletteView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.plusButtonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Design.contentStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ColorSettingPaletteView {

    func set(color: UIColor) {
        currentColorView.backgroundColor = color
    }
    
}

extension ColorSettingPaletteView {

    private func initView() {
        palleteView.colors = colors
        contentStackView.addArrangedSubview(currentColorView)
        contentStackView.addArrangedSubview(separator)
        contentStackView.addArrangedSubview(plusButton)
        contentStackView.addArrangedSubview(palleteView)
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currentColorView.widthAnchor.constraint(equalToConstant: Design.currentColorViewDiameter),
            currentColorView.heightAnchor.constraint(equalToConstant: Design.currentColorViewDiameter),

            separator.widthAnchor.constraint(equalToConstant: Design.currentColorBorderWidth),
            separator.heightAnchor.constraint(equalToConstant: Design.separatorHeight),

            palleteView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: leftAnchor,
                                                   constant: Design.contentSideMargin),
            contentStackView.rightAnchor.constraint(equalTo: rightAnchor,
                                                    constant: -Design.contentSideMargin),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bindEvent() {

    }

}
