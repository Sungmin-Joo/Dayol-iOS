//
//  ColorSettingPaletteView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/18.
//

import UIKit
import Combine
import RxSwift

private enum Design {
    static let actionButtonRadius: CGFloat = 18.0
    static let actionButtonDiameter: CGFloat = 36.0

    static let paletteInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16.0)

    static let contentStackViewSpacing: CGFloat = 16.0
    static let contentSideMargin: CGFloat = 20.0

    static let separatorColor = UIColor(decimalRed: 200, green: 202, blue: 204)
    static let separatorWidth: CGFloat = 1
    static let separatorHeight: CGFloat = 24

    static let whitePlusImage = Assets.Image.ToolBar.ColorPicker.whitePlus
    static let blackPlusImage = Assets.Image.ToolBar.ColorPicker.blackPlus
    static let whiteMinusImage = Assets.Image.ToolBar.ColorPicker.whiteMinus
    static let blackMinusImage = Assets.Image.ToolBar.ColorPicker.blackMinus
}

class ColorSettingPaletteView: UIView {

    private let disposeBag = DisposeBag()
    private var cancellable: [AnyCancellable] = []
    var didChangePaletteColor: ((UIColor) -> Void)?
    let viewModel = ColorSettingPaletteViewModel()

    // MARK: UI Property

    private let paletteView: DYColorPaletteView = {
        let view = DYColorPaletteView()
        view.backgroundColor = .clear
        view.setInset(Design.paletteInset)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let paletteActionButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Design.actionButtonDiameter / 2.0
        button.setImage(Design.whitePlusImage, for: .normal)
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

    private func set(color: UIColor) {
        if let oldColor = paletteView.currentDYColor?.uiColor {
            if oldColor != color {
                paletteView.deselectColorItem()
            }
        } else {
            if let paletteColor = color.toDYPaletteColor {
                paletteView.selectColor(paletteColor)
            }
        }
        updateActionButton(color)
    }

    private func updateActionButton(_ color: UIColor) {
        if paletteView.currentDYColor?.uiColor != nil {
            setMinusActionButton()
        } else {
            setPlusActionButton()
        }
        paletteActionButton.backgroundColor = color
    }

    private func setPlusActionButton() {
        let hexString = viewModel.currentHexColor.value
        let color = UIColor(hex: hexString)

        if color?.isHighBrightness == true {
            paletteActionButton.setImage(Design.blackPlusImage, for: .normal)
        } else {
            paletteActionButton.setImage(Design.whitePlusImage, for: .normal)
        }
    }

    private func setMinusActionButton() {
        guard let color = paletteView.currentDYColor?.uiColor else { return }

        if color.toDYPaletteColor?.isPresetColor == true {
            paletteActionButton.setImage(nil, for: .normal)
            return
        }

        if color.isHighBrightness {
            paletteActionButton.setImage(Design.blackMinusImage, for: .normal)
        } else {
            paletteActionButton.setImage(Design.whiteMinusImage, for: .normal)
        }
    }
    
}

extension ColorSettingPaletteView {

    private func initView() {
        contentStackView.addArrangedSubview(paletteActionButton)
        contentStackView.addArrangedSubview(separator)
        contentStackView.addArrangedSubview(paletteView)
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            paletteActionButton.widthAnchor.constraint(equalToConstant: Design.actionButtonDiameter),
            paletteActionButton.heightAnchor.constraint(equalToConstant: Design.actionButtonDiameter),

            separator.widthAnchor.constraint(equalToConstant: Design.separatorWidth),
            separator.heightAnchor.constraint(equalToConstant: Design.separatorHeight),

            paletteView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: leftAnchor,
                                                   constant: Design.contentSideMargin),
            contentStackView.rightAnchor.constraint(equalTo: rightAnchor,
                                                    constant: -Design.contentSideMargin),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bindEvent() {

        viewModel.paletteColors.sink { [weak self] colors in
            guard let self = self else { return }
            // TODO: - 디테일 구현
            // -> 모달 노출 후 셀렉트된 셀로 이동하도록 구현 필요
            self.paletteView.colors = colors
        }
        .store(in: &cancellable)

        viewModel.currentHexColor.sink { [weak self] hexString in
            guard let color = UIColor(hex: hexString) else { return }
            self?.set(color: color)
        }
        .store(in: &cancellable)

        // TODO: - 공통 paletteView 개편 시 rx 제거하는게 좋겠습니다.
        paletteView.changedColor
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] color in
                guard let self = self else { return }
                let hexString = color.uiColor.toHexString
                self.viewModel.currentHexColor.send(hexString)
                self.didChangePaletteColor?(color.uiColor)
            })
            .disposed(by: disposeBag)

        paletteActionButton.addTarget(self,
                                      action: #selector(didTapPaletteActionButton),
                                      for: .touchUpInside)
    }

    @objc func didTapPaletteActionButton() {
        // 파레트 액션 (컬러 추가, 삭제)
        if let currentDYColor = paletteView.currentDYColor {
            viewModel.removeCustomColor(currentDYColor)
            setPlusActionButton()
        } else {
            let currentHexColor = viewModel.currentHexColor.value
            if let paletteColor = UIColor(hex: currentHexColor)?.toDYPaletteColor {
                viewModel.addCustomColor(paletteColor)
                paletteView.selectColor(paletteColor)
                setMinusActionButton()
            }
        }
    }

}

private extension UIColor {

    var rgbValue: (red: Int, green: Int, blue: Int)? {
        var hexFormatted: String = toHexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        if hexFormatted.count != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        let r: Int = Int((rgbValue & 0xFF0000) >> 16)
        let g: Int = Int((rgbValue & 0x00FF00) >> 8)
        let b: Int = Int(rgbValue & 0x0000FF)

        return (r, g, b)
    }

    var toDYPaletteColor: DYPaletteColor? {
        guard let rgbValue = rgbValue else { return nil }

        let colorSet = DYPaletteColor.ColorSet(red: rgbValue.red,
                                               green: rgbValue.green,
                                               blue: rgbValue.blue)

        if let color = DYPaletteColor.colorPreset.filter({ $0.colorSet == colorSet }).first {
            return color
        }

        return DYPaletteColor.custom(red: rgbValue.red,
                                     green: rgbValue.green,
                                     blue: rgbValue.blue)
    }

    var isHighBrightness: Bool {
        guard let rgbValue = rgbValue else { return false }

        let threshold = 200

        // spec: r, g, b 중 하나라도 200을 넘으면 밝은 컬러로 처리
        if rgbValue.red > threshold || rgbValue.green > threshold || rgbValue.blue > threshold {
            return true
        }

        return false
    }

}
