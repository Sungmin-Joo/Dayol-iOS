//
//  PencilAlphaSettingView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/21.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

private enum Design {
    static let plusButtonImage = Assets.Image.ToolBar.TextStyle.plusButton
    static let minusButtonImage = Assets.Image.ToolBar.TextStyle.minusButton

    static let titleFont: UIFont = .appleBold(size: 15.0)
    static let titleSpacing: CGFloat = -0.28
    static let titleColor: UIColor = .gray900

    static let alphaInfoViewWidth: CGFloat = 48.0
    static let alphaInfoViewHeight: CGFloat = 30.0

}

private enum Text {
    static var pencilAlphaTitle: String {
        return "edit_pen_opacity".localized
    }
}

class PencilAlphaSettingView: UIView {
    private let maxDecimalAlpha = 100
    private let minDecimalAlpha = 20

    let decimalAlphaSubject = CurrentValueSubject<Int, Never>(100)
    private var cancellable: [AnyCancellable] = []
    private let disposeBag = DisposeBag()

    // MARK: UI Property

    private let titleLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString.build(text: Text.pencilAlphaTitle,
                                                      font: Design.titleFont,
                                                      align: .left,
                                                      letterSpacing: Design.titleSpacing, foregroundColor: Design.titleColor)
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    private let alphaLabelView: PencilAlphaInfoView = {
        let view = PencilAlphaInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
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

extension PencilAlphaSettingView {

    func set(color: UIColor) {
        alphaLabelView.set(color: color)
    }
}

extension PencilAlphaSettingView {

    private func initView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(plusButton)
        contentStackView.addArrangedSubview(alphaLabelView)
        contentStackView.addArrangedSubview(minusButton)
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            alphaLabelView.widthAnchor.constraint(equalToConstant: Design.alphaInfoViewWidth),
            alphaLabelView.heightAnchor.constraint(equalToConstant: Design.alphaInfoViewHeight),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func bindEvent() {
        decimalAlphaSubject.sink { [weak self] decimalAlpha in
            self?.alphaLabelView.set(decimalAlpha: decimalAlpha)
        }
        .store(in: &cancellable)

        plusButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let decimalAlpha = self.decimalAlphaSubject.value
                if decimalAlpha < self.maxDecimalAlpha {
                    self.decimalAlphaSubject.send(decimalAlpha + 20)
                }
            }
            .disposed(by: disposeBag)

        minusButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let decimalAlpha = self.decimalAlphaSubject.value
                if decimalAlpha > self.minDecimalAlpha {
                    self.decimalAlphaSubject.send(decimalAlpha - 20)
                }
            }
            .disposed(by: disposeBag)
    }

}
