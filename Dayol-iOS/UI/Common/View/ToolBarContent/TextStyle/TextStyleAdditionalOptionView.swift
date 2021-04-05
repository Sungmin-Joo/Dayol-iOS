//
//  TextStyleAdditionalOptionView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let selectedButtonImage = UIImage(named: TextStyleModel.AdditionalOption.selectedImageName)
    static let stackViewSpacing: CGFloat = 4.0
}

class TextStyleAdditionalOptionView: UIView {

    private let disposeBag = DisposeBag()
    var currnetOptions: Set<TextStyleModel.AdditionalOption> = [] {
        didSet { updateCurrentState() }
    }

    // MARK: - UI Property

    private let boldButton: UIButton = {
        let image = UIImage(named: TextStyleModel.AdditionalOption.bold.backgroundImageName)
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.setImage(Design.selectedButtonImage, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cancelLineButton: UIButton = {
        let image = UIImage(named: TextStyleModel.AdditionalOption.cancelLine.backgroundImageName)
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.setImage(Design.selectedButtonImage, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let underLineButton: UIButton = {
        let image = UIImage(named: TextStyleModel.AdditionalOption.underLine.backgroundImageName)
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.setImage(Design.selectedButtonImage, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Design.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        initView()
        bindEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateCurrentState() {
        let hasBoldOption = currnetOptions.contains(.bold)
        let hasCancelLineOption = currnetOptions.contains(.cancelLine)
        let hasUnderLineOption = currnetOptions.contains(.underLine)

        boldButton.isSelected = hasBoldOption
        cancelLineButton.isSelected = hasCancelLineOption
        underLineButton.isSelected = hasUnderLineOption
    }

}

// MARK: - Init

extension TextStyleAdditionalOptionView {

    private func initView() {
        stackView.addArrangedSubview(boldButton)
        stackView.addArrangedSubview(cancelLineButton)
        stackView.addArrangedSubview(underLineButton)
        addSubViewPinEdge(stackView)
    }

    private func bindEvent() {
        boldButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if self.currnetOptions.contains(.bold) {
                    self.currnetOptions.remove(.bold)
                } else {
                    self.currnetOptions.insert(.bold)
                }
            }
            .disposed(by: disposeBag)

        cancelLineButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if self.currnetOptions.contains(.cancelLine) {
                    self.currnetOptions.remove(.cancelLine)
                } else {
                    self.currnetOptions.insert(.cancelLine)
                }
            }
            .disposed(by: disposeBag)

        underLineButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if self.currnetOptions.contains(.underLine) {
                    self.currnetOptions.remove(.underLine)
                } else {
                    self.currnetOptions.insert(.underLine)
                }
            }
            .disposed(by: disposeBag)
    }

}
