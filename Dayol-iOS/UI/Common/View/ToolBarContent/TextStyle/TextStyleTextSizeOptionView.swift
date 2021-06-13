//
//  TextStyleTextSizeOptionView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

private enum Design {
    static let borderRadius: CGFloat = 4.0
    static let borderWidth: CGFloat = 1.0
    static let borderColor = UIColor(white: 234.0 / 255.0, alpha: 1.0)

    static let textColor: UIColor = .gray900
    static let textKern: CGFloat = -0.3
    static let font: UIFont = .systemFont(ofSize: 16.0, weight: .regular)

    static let plusButtonImage = Assets.Image.ToolBar.TextStyle.plusButton
    static let minusButtonImage = Assets.Image.ToolBar.TextStyle.minusButton

    static let buttonSideMargin: CGFloat = 7.0
    static let buttonSize = CGSize(width: 30, height: 30)

    static let miniumumTextSize = 8
    static let maximumTextSize = 30
}

class TextStyleTextSizeOptionView: UIView {

    private let disposeBag = DisposeBag()
    let textSizeSubject = CurrentValueSubject<Int, Never>(0)
    var currentSize = 0 {
        didSet { setTextSize() }
    }

    // MARK: - UI Property

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.plusButtonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.minusButtonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    private func setTextSize() {
        let attributedText = NSAttributedString.build(text: String(currentSize),
                                                      font: Design.font,
                                                      align: .center,
                                                      letterSpacing: Design.textKern,
                                                      foregroundColor: Design.textColor)
        sizeLabel.attributedText = attributedText
        textSizeSubject.send(currentSize)
    }

}

extension TextStyleTextSizeOptionView {

    private func initView() {
        backgroundColor = .white
        layer.borderWidth = Design.borderWidth
        layer.borderColor = Design.borderColor.cgColor
        layer.cornerRadius = Design.borderRadius

        addSubview(sizeLabel)
        addSubview(plusButton)
        addSubview(minusButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            plusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: Design.buttonSideMargin),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            minusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.buttonSideMargin),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            sizeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sizeLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func bindEvent() {
        plusButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                // TODO: - 텍스트 사이즈 맥시멈 값 스펙 확인
                if self.currentSize < Design.maximumTextSize {
                    self.currentSize += 1
                }
            }
            .disposed(by: disposeBag)

        minusButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                // TODO: - 텍스트 사이즈 미니멈 값 스펙 확인
                if self.currentSize > Design.miniumumTextSize {
                    self.currentSize -= 1
                }
            }
            .disposed(by: disposeBag)
    }

}
