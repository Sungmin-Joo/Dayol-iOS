//
//  TextStyleLineSpaceOptionView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let titleFont = UIFont.appleRegular(size: 16.0)
    static let titleSpacing: CGFloat = -0.62
    static let infoTitleFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
    static let infoTitleSpacing: CGFloat = -0.55
    static let titleColor: UIColor = .gray900

    static let titleLeftMargin: CGFloat = 17.0
    static let infoLabelLeftMargin: CGFloat = 27.0
    static let plusButtonRightMargin: CGFloat = 16.0
    static let sliderLeftMargin: CGFloat = 8.0
    static let sliderRightMargin: CGFloat = 21.0

    static let plusButtonImage = Assets.Image.ToolBar.TextStyle.plusButton
    static let minusButtonImage = Assets.Image.ToolBar.TextStyle.minusButton

    static let bottomLineColor = UIColor(white: 220, alpha: 1.0)
    static let sliderTintColor = UIColor(decimalRed: 216, green: 218, blue: 220)

}

private enum Text {
    static let lineSpaceTitle = "text_style_line_space".localized
}

class TextStyleLineSpaceOptionView: UIView {

    static let minimumLineSpace: Float = 20
    static let maximumLineSpace: Float = 30

    private let disposeBag = DisposeBag()

    var currentLineSpacing = 0 {
        didSet { updateCurrentState() }
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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(text: Text.lineSpaceTitle,
                                                        font: Design.titleFont,
                                                        align: .center,
                                                        letterSpacing: Design.titleSpacing,
                                                        foregroundColor: Design.titleColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spacingInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let slider: UISlider = {
        let slider = UISlider()
        slider.maximumTrackTintColor = Design.sliderTintColor
        slider.minimumTrackTintColor = Design.sliderTintColor
        slider.minimumValue = TextStyleLineSpaceOptionView.minimumLineSpace
        slider.maximumValue = TextStyleLineSpaceOptionView.maximumLineSpace
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.bottomLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    private func updateCurrentState() {
        let text = String(currentLineSpacing) + "pt"
        spacingInfoLabel.attributedText = NSAttributedString.build(text: text,
                                                                   font: Design.infoTitleFont,
                                                                   align: .center,
                                                                   letterSpacing: Design.infoTitleSpacing,
                                                                   foregroundColor: Design.titleColor)
        slider.setValue(Float(currentLineSpacing), animated: false)
    }

}

extension TextStyleLineSpaceOptionView {

    private func initView() {
        addSubview(titleLabel)
        addSubview(spacingInfoLabel)
        addSubview(slider)
        addSubview(minusButton)
        addSubview(plusButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                             constant: Design.titleLeftMargin),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            spacingInfoLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor,
                                                   constant: Design.infoLabelLeftMargin),
            spacingInfoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            plusButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                              constant: -Design.plusButtonRightMargin),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            minusButton.rightAnchor.constraint(equalTo: plusButton.leftAnchor),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            slider.leftAnchor.constraint(equalTo: spacingInfoLabel.rightAnchor,
                                         constant: Design.sliderLeftMargin),
            slider.rightAnchor.constraint(equalTo: minusButton.leftAnchor,
                                         constant: -Design.sliderRightMargin)
        ])
    }

    private func bindEvent() {
        slider.rx.value
            .bind { [weak self] value in
                guard let self = self else { return }
                self.currentLineSpacing = Int(value)
            }
            .disposed(by: disposeBag)

        plusButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if self.currentLineSpacing < Int(Self.maximumLineSpace) {
                    self.currentLineSpacing += 1
                }
            }
            .disposed(by: disposeBag)

        minusButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if self.currentLineSpacing > Int(Self.minimumLineSpace) {
                    self.currentLineSpacing -= 1
                }
            }
            .disposed(by: disposeBag)
    }

}
