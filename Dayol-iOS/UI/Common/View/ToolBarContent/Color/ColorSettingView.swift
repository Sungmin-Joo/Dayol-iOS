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
    static let colorPickerContentViewHeight: CGFloat = 246.0
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

    let colorSubject = PassthroughSubject<UIColor, Never>()
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

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Text.paletteTab, Text.customTab])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let colorPickerContentView: ColorPickerContentView = {
        let view = ColorPickerContentView()
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
        colorPickerContentView.set(color: color)
    }
}

extension ColorSettingView {

    private func initView() {
        addSubview(colorSettingPaletteView)
        addSubview(separator)
        addSubview(segmentedControl)
        addSubview(colorPickerContentView)

        segmentedControl.addTarget(self,
                                   action: #selector(segconChanged(segcon:)),
                                   for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorSettingPaletteView.topAnchor.constraint(equalTo: topAnchor),
            colorSettingPaletteView.widthAnchor.constraint(equalTo: widthAnchor),
            colorSettingPaletteView.heightAnchor.constraint(equalToConstant: Design.colorSettingPalletViewHeight),
            colorSettingPaletteView.centerXAnchor.constraint(equalTo: centerXAnchor),

            separator.topAnchor.constraint(equalTo: colorSettingPaletteView.bottomAnchor,
                                           constant: Design.contentSpacing),
            separator.widthAnchor.constraint(equalTo: colorSettingPaletteView.widthAnchor,
                                             constant: -Design.separatorSideMargin * 2),
            separator.heightAnchor.constraint(equalToConstant: Design.separatorHeight),
            separator.centerXAnchor.constraint(equalTo: centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: separator.bottomAnchor,
                                                  constant: Design.contentSpacing),
            segmentedControl.widthAnchor.constraint(equalToConstant: Design.segmentedControlWidth),
            segmentedControl.heightAnchor.constraint(equalToConstant: Design.segmentedControlHeight),
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),

            colorPickerContentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                                        constant: Design.contentSpacing),
            colorPickerContentView.widthAnchor.constraint(equalToConstant: Design.colorPickerContentViewWidth),
            colorPickerContentView.heightAnchor.constraint(equalToConstant: Design.colorPickerContentViewHeight),
            colorPickerContentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorPickerContentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bindEvent() {
        colorPickerContentView.colorSubject.sink { [weak self] color in
            self?.colorSettingPaletteView.set(color: color)
            self?.colorSubject.send(color)
        }
        .store(in: &cancellable)
    }

}

extension ColorSettingView {

    @objc
    func segconChanged(segcon: UISegmentedControl) {
        if segcon.selectedSegmentIndex == 0 {
            colorPickerContentView.pickModeSubject.send(.custom)
        } else {
            colorPickerContentView.pickModeSubject.send(.palette)
        }
    }
    
}
