//
//  ColorPickerView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/19.
//

import UIKit
import Combine

class ColorPickerContentView: UIView {

    enum PickMode {
        case custom, palette
    }

    let colorSubject = PassthroughSubject<UIColor, Never>()
    let pickModeSubject = CurrentValueSubject<PickMode, Never>(.custom)
    private var cancellable: [AnyCancellable] = []
    
    // MARK: UIProperty

    private let colorPicker: ColorPicker = {
        let picker = ColorPicker()
        picker.set(color: UIColor(displayP3Red: 1.0, green: 1.0, blue: 0, alpha: 1))
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    init() {
        super.init(frame: .zero)
        initView()
        bindEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ColorPickerContentView {

    func set(color: UIColor) {
        colorPicker.set(color: color)
    }

}

extension ColorPickerContentView {

    private func initView() {
        colorPicker.addTarget(self, action: #selector(handleColorChanged(picker:)), for: .valueChanged)
        addSubview(colorPicker)
        addSubViewPinEdge(colorPicker)
    }

    private func bindEvent() {
        pickModeSubject.sink { [weak self] value in
            guard let self = self else { return }
            if value == .custom {
                self.colorPicker.isHidden = false
            } else {
                self.colorPicker.isHidden = true
            }
        }
        .store(in: &cancellable)
    }

}

extension ColorPickerContentView {

    @objc func handleColorChanged(picker: ColorPicker) {
        colorSubject.send(picker.color)
    }

}
