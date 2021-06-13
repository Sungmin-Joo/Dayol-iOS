//
//  HRColorPicker.swift
//  ColorPicker3
//
//  Created by Hayashi Ryota on 2019/02/16.
//  Copyright © 2019 Hayashi Ryota. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

private enum Design {
    static let pickerDiameter: CGFloat = 200.0
    static let sliderMinValue: Float = 0.0
    static let sliderMaxValue: Float = 1.0
    static let sliderTackHeight: CGFloat = 10.0
}
public final class ColorPicker: UIControl {

    private let disposeBag = DisposeBag()
    private(set) lazy var colorSpace: HRColorSpace = .sRGB

    public var color: UIColor {
        get {
            return hsvColor.uiColor
        }
    }

    private let colorMap = ColorMapView()
    private let colorMapCursor = ColorMapCursor()
    private let slider: ColorBrightSlider = {
        let slider = ColorBrightSlider(trackHeight: Design.sliderTackHeight)
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.minimumValue = Design.sliderMinValue
        slider.maximumValue = Design.sliderMaxValue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private lazy var hsvColor: HSVColor = HSVColor(color: .white, colorSpace: .sRGB)

    private let feedbackGenerator = UISelectionFeedbackGenerator()
    var isPanning: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        colorSpace = .sRGB
        addSubview(colorMap)
        addSubview(colorMapCursor)
        addSubview(slider)

        let colorMapPan = UIPanGestureRecognizer(target: self, action: #selector(self.handleColorMapPan(pan:)))
        colorMapPan.delegate = self
        colorMap.addGestureRecognizer(colorMapPan)

        feedbackGenerator.prepare()
        setupConstraints()
        bindEvent()
    }

    public func set(color: UIColor) {
        colorMap.colorSpace = colorSpace
        hsvColor = HSVColor(color: color, colorSpace: colorSpace)
        let brightness = hsvColor.brightness
        slider.setValue(Float(brightness), animated: true)
        if superview != nil {
            mapColorToView()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        mapColorToView()
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isPanning == false {
            handleColorMapTap(point: point)
        }
        return super.hitTest(point, with: event)
    }

    private func mapColorToView() {
        let pickerPresentColor = hsvColor.hueAndSaturation.with(brightness: 1)
        colorMapCursor.center =  colorMap.convert(colorMap.position(for: hsvColor.hueAndSaturation), to: self)
        colorMapCursor.set(hsvColor: pickerPresentColor)
        slider.setGradient(baseColor: hsvColor)
    }

    @objc
    private func handleColorMapPan(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began, .changed:
            isPanning = true
        default:
            isPanning = false
        }

        let selected = colorMap.color(at: pan.location(in: colorMap))
        hsvColor = selected.with(brightness: hsvColor.brightness)
        mapColorToView()
        feedbackIfNeeds()
        sendActionIfNeeds()
    }

    private func handleColorMapTap(point: CGPoint) {
        let convertedPoint = convert(point, to: colorMap)

        if colorMap.frame.contains(convertedPoint) == false {
            return
        }

        let selectedColor = colorMap.color(at: convertedPoint)
        hsvColor = selectedColor.with(brightness: hsvColor.brightness)
        mapColorToView()
        feedbackIfNeeds()
        sendActionIfNeeds()
    }

    private var prevFeedbackedHSV: HSVColor?
    private func feedbackIfNeeds() {
        if prevFeedbackedHSV != hsvColor {
            feedbackGenerator.selectionChanged()
            prevFeedbackedHSV = hsvColor
        }
    }

    // ↑似た構造ではあるのだが、本質的に異なるので分けた
    private var prevSentActionHSV: HSVColor?
    private func sendActionIfNeeds() {
        if prevSentActionHSV != hsvColor {
            sendActions(for: .valueChanged)
            prevSentActionHSV = hsvColor
        }
    }

    private func setupConstraints() {
        colorMap.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorMap.topAnchor.constraint(equalTo: topAnchor),
            colorMap.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorMap.widthAnchor.constraint(equalToConstant: Design.pickerDiameter),
            colorMap.heightAnchor.constraint(equalToConstant: Design.pickerDiameter),

            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bindEvent() {
        slider.rx.value
            .bind { [weak self] brightness in
                guard let self = self else { return }
                self.hsvColor = self.hsvColor.hueAndSaturation.with(brightness: CGFloat(brightness))
                self.sendActionIfNeeds()
            }
            .disposed(by: disposeBag)

    }
}

extension ColorPicker: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == colorMap, otherGestureRecognizer.view == colorMap {
            return true
        }
        return false
    }
}
