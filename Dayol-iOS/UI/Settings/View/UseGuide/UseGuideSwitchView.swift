//
//  UseGuideSwitchView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/08.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let selectedColor: UIColor = .dayolBrown
    static let normalColor: UIColor = .white
    static let borderColor: UIColor = .gray300
    static let borderWidth: CGFloat = 1.0
    static let cornerRadius: CGFloat = 8.0

    static func attributedString(text: String, isSelected: Bool) -> NSAttributedString {
        let foregroundColor: UIColor = isSelected ? .white : .gray900
        return NSAttributedString.build(
            text: text,
            font: .boldSystemFont(ofSize: 16),
            align: .center,
            letterSpacing: -0.3,
            foregroundColor: foregroundColor
        )
    }
}

class UseGuideSwitchView: UIView {

    private let disposeBag = DisposeBag()
    var styleSubject: BehaviorSubject<UseGuide.Style>
    var style: UseGuide.Style {
        didSet { updateCurrentState() }
    }

    // MARK: UI Property

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let leftButton: UIButton = {
        let button = UIButton()
        let normalTitle = Design.attributedString(text: UseGuide.Style.vertical.text, isSelected: false)
        let selectedTitle = Design.attributedString(text: UseGuide.Style.vertical.text, isSelected: true)
        button.setAttributedTitle(normalTitle, for: .normal)
        button.setAttributedTitle(selectedTitle, for: .selected)
        button.setBackgroundColor(Design.normalColor, for: .normal)
        button.setBackgroundColor(Design.selectedColor, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let rightButton: UIButton = {
        let button = UIButton()
        let normalTitle = Design.attributedString(text: UseGuide.Style.horizontal.text, isSelected: false)
        let selectedTitle = Design.attributedString(text: UseGuide.Style.horizontal.text, isSelected: true)
        button.setAttributedTitle(normalTitle, for: .normal)
        button.setAttributedTitle(selectedTitle, for: .selected)
        button.setBackgroundColor(Design.normalColor, for: .normal)
        button.setBackgroundColor(Design.selectedColor, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: Init

    init(style: UseGuide.Style) {
        self.style = style
        self.styleSubject = BehaviorSubject(value: style)
        super.init(frame: .zero)
        initView()
        setupConstraints()
        bindEvent()
        updateCurrentState()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func updateCurrentState() {
        if style == .vertical {
            rightButton.isSelected = false
            leftButton.isSelected = true
        } else {
            rightButton.isSelected = true
            leftButton.isSelected = false
        }
    }

}

// MARK: - Private initial function

private extension UseGuideSwitchView {

    func initView() {
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rightButton)
        addSubview(stackView)

        layer.borderWidth = Design.borderWidth
        layer.borderColor = Design.borderColor.cgColor
        layer.cornerRadius = Design.cornerRadius
        layer.masksToBounds = true
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func bindEvent() {
        leftButton.rx.tap
            .bind { [weak self] in
                self?.style = .vertical
                self?.styleSubject.onNext(.vertical)
            }
            .disposed(by: disposeBag)

        rightButton.rx.tap
            .bind { [weak self] in
                self?.style = .horizontal
                self?.styleSubject.onNext(.horizontal)
            }
            .disposed(by: disposeBag)
    }

}
