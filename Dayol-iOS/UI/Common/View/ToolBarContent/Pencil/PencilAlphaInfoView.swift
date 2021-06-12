//
//  PencilAlphaInfoView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/21.
//

import UIKit

private enum Design {
    static let infoBackgroundImage = Assets.Image.ToolBar.Pencil.alphaInfoBackground

    static let borderColor = UIColor(decimalRed: 207, green: 207, blue: 207)
    static let borderWidth: CGFloat = 1
    static let borderRadius: CGFloat = 5.0

    static let titleFont: UIFont = .appleBold(size: 14.0)
    static let titleSpacing: CGFloat = -0.26
    static let titleColor: UIColor = .gray900
    static let titleSubColor: UIColor = .white
    static let titleSuffix: String = "%"
}

class PencilAlphaInfoView: UIView {

    // MARK: UI Property

    private let infoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backgroundImageView: UIImageView = {
        let view = UIImageView(image: Design.infoBackgroundImage)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let currentColorView = UIView()

    init() {
        super.init(frame: .zero)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PencilAlphaInfoView {

    func set(color: UIColor) {
        currentColorView.backgroundColor = color
        updateLabelColor()
    }

    func set(alpha: CGFloat) {
        let decimalAlpha = Int(alpha * 100)
        let text = String(decimalAlpha) + Design.titleSuffix
        let attributedText = NSAttributedString.build(text: text,
                                                      font: Design.titleFont,
                                                      align: .center,
                                                      letterSpacing: Design.titleSpacing, foregroundColor: Design.titleColor)
        infoLabel.attributedText = attributedText
        currentColorView.alpha = alpha
        updateLabelColor()
    }

    private func updateLabelColor() {
        if currentColorView.alpha < 0.5 {
            infoLabel.textColor = Design.titleColor
        } else if currentColorView.backgroundColor?.isHighBrightness == true {
            infoLabel.textColor = Design.titleColor
        } else {
            infoLabel.textColor = Design.titleSubColor
        }
    }

}

extension PencilAlphaInfoView {

    private func initView() {
        layer.borderWidth = Design.borderWidth
        layer.borderColor = Design.borderColor.cgColor
        layer.cornerRadius = Design.borderRadius
        layer.masksToBounds = true
        
        addSubViewPinEdge(backgroundImageView)
        addSubViewPinEdge(currentColorView)
        addSubViewPinEdge(infoLabel)
    }

}

private extension UIColor {
    var isHighBrightness: Bool {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        let threshold: CGFloat = 200 / 255

        // spec: r, g, b 중 하나라도 200을 넘으면 밝은 컬러로 처리
        if red > threshold || green > threshold || blue > threshold {
            return true
        }

        return false
    }
}
