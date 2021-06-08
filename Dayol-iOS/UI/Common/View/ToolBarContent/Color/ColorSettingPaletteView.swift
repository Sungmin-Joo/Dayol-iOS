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

    private let disposeBag = DisposeBag()
    private var cancellable: [AnyCancellable] = []
    let viewModel = ColorSettingPaletteViewModel()

    // MARK: UI Property

    private let currentColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Design.currentColorViewRadius
        view.layer.borderWidth = Design.currentColorBorderWidth
        view.layer.borderColor = Design.currentColorBorderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // TODO: - 오타 수정
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

    private let paletteActionButton: UIButton = {
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

    private func set(color: UIColor) {
        currentColorView.backgroundColor = color

        if let oldColor = palleteView.currentColor {
            if oldColor != color {
                palleteView.deselectColorItem()
            }
        } else {
            if let paletteColor = color.toDYPaletteColor {
                palleteView.selectColor(paletteColor)
            }
        }
    }
    
}

extension ColorSettingPaletteView {

    private func initView() {
        contentStackView.addArrangedSubview(currentColorView)
        contentStackView.addArrangedSubview(separator)
        contentStackView.addArrangedSubview(paletteActionButton)
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

        viewModel.paletteColors.sink { [weak self] colors in
            guard let self = self else { return }
            // TODO: - 디테일 구현
            // -> 모달 노출 후 셀렉트된 셀로 이동하도록 구현 필요
            self.palleteView.colors = colors
        }
        .store(in: &cancellable)

        viewModel.currentHexColor.sink { [weak self] hexString in
            guard let color = UIColor(hex: hexString) else { return }
            self?.set(color: color)
        }
        .store(in: &cancellable)

        // TODO: - 공통 palleteView 개편 시 rx 제거하는게 좋겠습니다.
        palleteView.changedColor
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] color in
                guard let self = self else { return }
                let hexString = color.uiColor.toHexString
                self.viewModel.currentHexColor.send(hexString)
            })
            .disposed(by: disposeBag)

        paletteActionButton.addTarget(self,
                                      action: #selector(didTapPaletteActionButton),
                                      for: .touchUpInside)
    }

    @objc func didTapPaletteActionButton() {
        // 파레트 액션 (컬러 추가, 삭제)
        if let currentPalleteColor = palleteView.currentColor {
            // 파레트 제거 기능
        } else {
            let currentHexColor = viewModel.currentHexColor.value
            if let paletteColor = UIColor(hex: currentHexColor)?.toDYPaletteColor {
                viewModel.addCustomColor(paletteColor)
                palleteView.selectColor(paletteColor)
            }
        }
    }

}

private extension UIColor {

    var toDYPaletteColor: DYPaletteColor? {
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

        return DYPaletteColor.custom(red: r, green: g, blue: b)
    }

}
