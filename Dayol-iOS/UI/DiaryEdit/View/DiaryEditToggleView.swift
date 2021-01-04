//
//  DiaryEditToggleView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let fontColor: UIColor = UIColor(decimalRed: 102, green: 102, blue: 102)
    static let font: UIFont = UIFont.appleMedium(size: 15)
    static let letterSapce: CGFloat = -0.28
    
    static let toggleTop: CGFloat = 19
    static let toggleBottom: CGFloat = 17
    static let toggleRight: CGFloat = 20
    static let toggleLeft: CGFloat = 6
    static let toggleHeight: CGFloat = 20
    static let toggleWidth: CGFloat = 36
    
    static let labelTop: CGFloat = 20
    static let labelBottom: CGFloat = 18
}

private enum Text {
    static let labelText = "다욜 마크"
}

class DiaryEditToggleView: UIView {
    private let toggleLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Design.font,
            .kern: Design.letterSapce
        ]
        let attributedText = NSMutableAttributedString(string: Text.labelText, attributes: attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Design.fontColor
        label.attributedText = attributedText
        label.sizeToFit()
        
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.isOn = false
        
        return switchView
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(toggleLabel)
        addSubview(toggleSwitch)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            toggleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Design.labelTop),
            toggleLabel.rightAnchor.constraint(equalTo: toggleSwitch.leftAnchor, constant: -Design.toggleLeft),
            toggleLabel.centerYAnchor.constraint(equalTo: toggleSwitch.centerYAnchor),
            
            toggleSwitch.topAnchor.constraint(equalTo: topAnchor, constant: Design.toggleTop),
            toggleSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.toggleRight),
            toggleSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.toggleBottom)
        ])
    }
}
