//
//  DYNavigationTitle.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/30.
//

import UIKit

private enum Design {
    static let titleFont = UIFont.appleBold(size: 19)
    static let titleLetterSpace: CGFloat = -0.35
}

class DYNavigationTitle: UIView {
    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.titleFont
        
        return label
    }()
    
    internal let horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    internal let verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }()
    
    init(text: String, color: UIColor) {
        super.init(frame: .zero)
        titleLabel.attributedText = attributedText(text: text, color: color)
        horizontalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(horizontalStack)
        addSubview(verticalStack)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func attributedText(text: String, color: UIColor) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .font: Design.titleFont,
            .kern: Design.titleLetterSpace,
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        
        return attributedText
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            verticalStack.leftAnchor.constraint(equalTo: leftAnchor),
            verticalStack.rightAnchor.constraint(equalTo: rightAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
