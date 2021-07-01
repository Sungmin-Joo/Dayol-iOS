//
//  DYToast.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/28.
//

import UIKit

private enum Design {
    static let defaultRadius: CGFloat = 8.0
    static let defaultBackgroundColor = UIColor.black
    static let defaultTextColor = UIColor.white
    static let defaultAttributes: [NSAttributedString.Key: Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.appleRegular(size: 15.0),
            .kern: -0.28,
            .foregroundColor: defaultTextColor
        ]
        return attributes
    }()
    static let defaultWidth: CGFloat = 335.0
    static let defaultHeight: CGFloat = 60.0
    static let toastDuration: TimeInterval = 3.0
}

struct DYToastConfigure {

    static let `deafault` = DYToastConfigure(cornerRadius: Design.defaultRadius,
                                             backgroundColor: Design.defaultBackgroundColor,
                                             attributes: Design.defaultAttributes,
                                             width: Design.defaultWidth,
                                             height: Design.defaultHeight,
                                             toastDuration: Design.toastDuration)

    var cornerRadius: CGFloat
    var backgroundColor: UIColor
    var attributes: [NSAttributedString.Key: Any]
    var width: CGFloat
    var height: CGFloat
    var toastDuration: TimeInterval
}

class DYToast: UILabel {

    let configure: DYToastConfigure

    init(configure: DYToastConfigure, text: String, numberOfLines: Int = 1) {
        self.configure = configure
        super.init(frame: .zero)
        initToast()
        setConstraints()
        setText(text, numberOfLines)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func initToast() {
        layer.cornerRadius = configure.cornerRadius
        layer.masksToBounds = true
        backgroundColor = configure.backgroundColor
    }

    private func setText(_ text: String, _ numberOfLines: Int) {
        let attributedText = NSAttributedString(string: text, attributes: configure.attributes)

        self.attributedText = attributedText
        self.numberOfLines = numberOfLines
    }

    private func setConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: configure.width),
            heightAnchor.constraint(equalToConstant: configure.height),
        ])
    }
}
