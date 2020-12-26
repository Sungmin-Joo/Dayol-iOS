//
//  DiaryLockerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

private enum Design {
    case big
    case medium
    case small

	var buttonInsetWithoutRight: CGFloat {
		switch self {
		case .big: return 30
		case .medium: return 15
		case .small: return 15 / 4
		}
	}
    
    var buttonRight: CGFloat {
        switch self {
        case .big: return 50
        case .medium: return 25
        case .small: return 25 / 4
        }
    }

	var buttonWidth: CGFloat {
		switch self {
		case .big: return 4.0
		case .medium: return 2.0
		case .small: return 0.5
		}
	}

	var buttonRadius: CGFloat {
		switch self {
		case .big: return 32
		case .medium: return 16
		case .small: return 4
		}
	}

	var rightRadius: CGFloat {
		switch self {
		case .big: return 8
		case .medium: return 4
		case .small: return 1
		}
	}

	var leftRadius: CGFloat {
		switch self {
		case .big: return 60
		case .medium: return 30
		case .small: return 30 / 4
		}
	}

	static let buttonColor: UIColor = .white
	static let buttonBorderColor: CGColor = UIColor(decimalRed: 0, green: 0, blue: 0).withAlphaComponent(0.1).cgColor
}

class DiaryLockerView: DifferentEdgeSettableView {
	private let design: Design

	private let lockImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}()

	private let buttonView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Design.buttonColor

		return view
	}()

	init(type: DiaryType, backgroundColor: UIColor?) {
        switch type {
        case .big: self.design = .big
        case .medium: self.design = .medium
        case .small: self.design = .small
        }
        super.init(topLeft: design.leftRadius,
                   topRight: design.rightRadius,
                   bottomLeft: design.leftRadius,
                   bottomRight: design.rightRadius)
		initView(backgroundColor: backgroundColor)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initView(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        addSubview(lockImage)
        addSubview(buttonView)
		setButtonView()
		setConstraints()
    }

	private func setButtonView() {
        buttonView.layer.borderWidth = design.buttonWidth
        buttonView.layer.cornerRadius = design.buttonRadius
		buttonView.layer.borderColor = Design.buttonBorderColor
		buttonView.layer.masksToBounds = true
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
            lockImage.topAnchor.constraint(equalTo: topAnchor, constant: design.buttonInsetWithoutRight),
			lockImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -design.buttonInsetWithoutRight),
			lockImage.leftAnchor.constraint(equalTo: leftAnchor, constant: design.buttonInsetWithoutRight),
			lockImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -design.buttonRight),

			buttonView.topAnchor.constraint(equalTo: topAnchor, constant: design.buttonInsetWithoutRight),
			buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -design.buttonInsetWithoutRight),
			buttonView.leftAnchor.constraint(equalTo: leftAnchor, constant: design.buttonInsetWithoutRight),
			buttonView.rightAnchor.constraint(equalTo: rightAnchor, constant: -design.buttonRight)
		])
	}
}
