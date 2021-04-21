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
    }

    func set(decimalAlpha: Int) {
        let text = String(decimalAlpha) + Design.titleSuffix
        let attributedText = NSAttributedString.build(text: text,
                                                      font: Design.titleFont,
                                                      align: .center,
                                                      letterSpacing: Design.titleSpacing, foregroundColor: Design.titleColor)
        infoLabel.attributedText = attributedText
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
