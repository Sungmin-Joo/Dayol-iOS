//
//  ColorSettingView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/19.
//

import UIKit
import Combine

private enum Design {
    static let colorSettingPalletViewHeight: CGFloat = 45.0

    static let separatorColor = UIColor.gray300
    static let separatorHeight: CGFloat = 1
    static let separatorSideMargin: CGFloat = 20.0

    static let contentSpacing: CGFloat = 20.0

    static let segmentedControlWidth: CGFloat = 250.0
    static let segmentedControlHeight: CGFloat = 32.0

    static let colorPickerContentViewWidth: CGFloat = 275.0
    static let colorPickerContentViewHeight: CGFloat = 262.0
}

private enum Text {
    static var paletteTab: String {
        return "edit_pen_palette".localized
    }
    static var customTab: String {
        return "edit_pen_custom".localized
    }
}

class ColorSettingView: UIView {

    let colorSubject = CurrentValueSubject<UIColor, Never>(.black)
    private var cancellable: [AnyCancellable] = []

    // MARK: UI Property

    private let colorSettingPaletteView: ColorSettingPaletteView = {
        let view = ColorSettingPaletteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let colorPicker: ColorPicker = {
        let picker = ColorPicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let spacer: UIView = {
        let view = UIView()
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
}

extension ColorSettingView {

    func set(color: UIColor) {
        colorSettingPaletteView.set(color: color)
        colorPicker.set(color: color)
    }

}

extension ColorSettingView {

    private func initView() {
        colorPicker.addTarget(self, action: #selector(handleColorChanged(picker:)), for: .valueChanged)

        addSubview(colorSettingPaletteView)
        addSubview(separator)
        addSubview(colorPicker)
        addSubview(spacer)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorSettingPaletteView.topAnchor.constraint(equalTo: topAnchor,
                                                         constant: Design.contentSpacing),
            colorSettingPaletteView.widthAnchor.constraint(equalTo: widthAnchor),
            colorSettingPaletteView.heightAnchor.constraint(equalToConstant: Design.colorSettingPalletViewHeight),
            colorSettingPaletteView.centerXAnchor.constraint(equalTo: centerXAnchor),

            separator.topAnchor.constraint(equalTo: colorSettingPaletteView.bottomAnchor,
                                           constant: Design.contentSpacing),
            separator.widthAnchor.constraint(equalTo: colorSettingPaletteView.widthAnchor,
                                             constant: -Design.separatorSideMargin * 2),
            separator.heightAnchor.constraint(equalToConstant: Design.separatorHeight),
            separator.centerXAnchor.constraint(equalTo: centerXAnchor),

            colorPicker.topAnchor.constraint(equalTo: separator.bottomAnchor,
                                                        constant: Design.contentSpacing),
            colorPicker.widthAnchor.constraint(equalToConstant: Design.colorPickerContentViewWidth),
            colorPicker.heightAnchor.constraint(equalToConstant: Design.colorPickerContentViewHeight),
            colorPicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorPicker.bottomAnchor.constraint(equalTo: spacer.topAnchor),

            spacer.leftAnchor.constraint(equalTo: leftAnchor),
            spacer.rightAnchor.constraint(equalTo: rightAnchor),
            spacer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bindEvent() {
        colorSettingPaletteView.colorSubject.sink { [weak self] color in
            self?.colorPicker.set(color: color)
            self?.colorSubject.send(color)
        }
        .store(in: &cancellable)
    }

}

extension ColorSettingView {

    @objc func handleColorChanged(picker: ColorPicker) {
        colorSettingPaletteView.set(color: picker.color)
        colorSubject.send(picker.color)
    }

}
