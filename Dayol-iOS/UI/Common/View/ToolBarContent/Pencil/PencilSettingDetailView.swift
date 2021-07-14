//
//  PencilSettingDetailView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/11.
//

import UIKit
import RxCocoa
import RxSwift

private enum Design {
    static let selectedImage = UIImage(named: "toolBar_color_detail_selected")
    static let buttonConatainerSize = CGSize(width: 184, height: 28)
    static let sliderSize = CGSize(width: 184, height: 20)
    static let sliderTrackHeight: CGFloat = 18.0
    static let contentsTopMargin: CGFloat = {
        if PencilSettingDetailView.shouldShowPenWidthSetting {
            return 8.0
        }
        return 16.0
    }()
    static let contentInset = UIEdgeInsets(top: contentsTopMargin, left: 12, bottom: 8, right: 12)
    static let contentSpacing: CGFloat = 16.0
    static let sliderMinValue: Float = 0.0
    static let sliderMaxValue: Float = 1.0
}

class PencilSettingDetailView: UIView {
    typealias DeatilSetting = (width: CGFloat, alpha: CGFloat)
    enum PenType: String {
        static let maxStep = 5

        case pen, pencil, marker

        func image(at index: Int) -> UIImage? {
            guard index < Self.maxStep else { return nil }
            return UIImage(named: "toolBar_color_detail_\(rawValue)\(index + 1)")
        }
    }

    static var shouldShowPenWidthSetting: Bool {
        return true
    }
    static var preferredSize: CGSize {
        if shouldShowPenWidthSetting {
            return CGSize(width: 208, height: 86)
        }
        return CGSize(width: 208, height: 32)
    }
    private let penType: PenType
    private let currentColor: UIColor
    private let disposeBag = DisposeBag()
    let currentDetailSettingSubject = PublishSubject<DeatilSetting>()

    // MARK: UI Property

    private lazy var stepButtons: [UIButton] = {
        var buttonArray: [UIButton] = []

        (0..<PenType.maxStep).forEach {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setBackgroundImage(penType.image(at: $0), for: .normal)
            button.setImage(Design.selectedImage, for: .selected)
            buttonArray.append(button)
        }
        return buttonArray
    }()

    private let buttonContrainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let alphaSlider: PencilSettingSlider = {
        let slider = PencilSettingSlider(trackHeight: Design.sliderTrackHeight)
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.minimumValue = Design.sliderMinValue
        slider.maximumValue = Design.sliderMaxValue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = Design.contentSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        alphaSlider.setGradient(baseColor: currentColor)
    }

    // MARK: Init

    init(penType: PenType, currentColor: UIColor) {
        self.penType = penType
        self.currentColor = currentColor
        super.init(frame: .zero)
        initView()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - Private Initialize

private extension PencilSettingDetailView {

    func initView() {
        if Self.shouldShowPenWidthSetting {
            stepButtons.forEach { buttonContrainer.addArrangedSubview($0) }
            contentStackView.addArrangedSubview(buttonContrainer)
        }
        contentStackView.addArrangedSubview(alphaSlider)

        addSubview(contentStackView)
    }

    func setupConstraints() {
        if Self.shouldShowPenWidthSetting {
            NSLayoutConstraint.activate([
                buttonContrainer.widthAnchor.constraint(equalToConstant: Design.buttonConatainerSize.width),
                buttonContrainer.heightAnchor.constraint(equalToConstant: Design.buttonConatainerSize.height)
            ])
        }

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: Design.contentInset.top),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.contentInset.left),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Design.contentInset.right),

            alphaSlider.widthAnchor.constraint(equalToConstant: Design.sliderSize.width),
            alphaSlider.heightAnchor.constraint(equalToConstant: Design.sliderSize.height)
        ])
    }

    func bindEvent() {
        stepButtons.forEach { button in
            button.rx.tap.bind { [weak self] in
                self?.stepButtons.forEach { $0.isSelected = false }
                button.isSelected = true
            }
            .disposed(by: disposeBag)
        }
    }

}
