//
//  UnderLineButton.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import UIKit

private enum Design {
    static let underLineColor = UIColor.black
    static let underLineHeight: CGFloat = 1.0
}

class UnderLineButton: UIButton {

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.underLineColor
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var underlineColor: UIColor = Design.underLineColor {
        didSet {
            underlineView.backgroundColor = underlineColor
        }
    }

    override var isSelected: Bool {
        didSet {
            underlineView.isHidden = isSelected ? false : true
        }
    }

    init() {
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupConstraints() {
        addSubview(underlineView)
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: Design.underLineHeight)
        ])
    }
}
