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
    
	var lockerHeight: CGFloat {
		switch self {
		case .big: return 120
		case .medium: return 60
		case .small: return 15
		}
	}

	var buttonInset: CGFloat {
		switch self {
		case .big: return 30
		case .medium: return 15
		case .small: return 15 / 4
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

	var leftViewWidth: CGFloat {
		switch self {
		case .big: return 120
		case .medium: return 60
		case .small: return 15
		}
	}

	var rightViewWidth: CGFloat {
		switch self {
		case .big: return 20
		case .medium: return 10
		case .small: return 10 / 4
		}
	}

	static let buttonColor: UIColor = .white
	static let buttonBorderColor: CGColor = UIColor(decimalRed: 0, green: 0, blue: 0).withAlphaComponent(0.1).cgColor
}

class DiaryLockerView: UIView {
	private let design: Design

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

	private let leftView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	private let rightView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()


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
		super.init(frame: .zero)
		initView(backgroundColor: backgroundColor)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initView(backgroundColor: UIColor?) {
		self.translatesAutoresizingMaskIntoConstraints = false
		stackView.addArrangedSubview(leftView)
		stackView.addArrangedSubview(rightView)
		addSubview(stackView)
		setLeftView(backgroundColor: backgroundColor)
		setRightView(backgroundColor: backgroundColor)
		setButtonView()
		setConstraints()
	}

	private func setLeftView(backgroundColor: UIColor?) {
		leftView.backgroundColor = backgroundColor
		leftView.addSubview(lockImage)
		leftView.addSubview(buttonView)
		leftView.clipsToBounds = true
        leftView.layer.cornerRadius = design.leftRadius
		leftView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
	}

	private func setRightView(backgroundColor: UIColor?) {
		rightView.backgroundColor = backgroundColor
		rightView.clipsToBounds = true
        rightView.layer.cornerRadius = design.rightRadius
		rightView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
	}

	private func setButtonView() {
        buttonView.layer.borderWidth = design.buttonWidth
        buttonView.layer.cornerRadius = design.buttonRadius
		buttonView.layer.borderColor = Design.buttonBorderColor
		buttonView.layer.masksToBounds = true
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
            leftView.widthAnchor.constraint(equalToConstant: design.leftViewWidth),
            rightView.widthAnchor.constraint(equalToConstant: design.rightViewWidth),
            
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.leftAnchor.constraint(equalTo: leftAnchor),
			stackView.rightAnchor.constraint(equalTo: rightAnchor),

			lockImage.topAnchor.constraint(equalTo: topAnchor, constant: design.buttonInset),
			lockImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -design.buttonInset),
			lockImage.leftAnchor.constraint(equalTo: leftAnchor, constant: design.buttonInset),
			lockImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -design.buttonInset),

			buttonView.topAnchor.constraint(equalTo: topAnchor, constant: design.buttonInset),
			buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -design.buttonInset),
			buttonView.leftAnchor.constraint(equalTo: leftAnchor, constant: design.buttonInset),
			buttonView.rightAnchor.constraint(equalTo: rightAnchor, constant: -design.buttonInset)
		])
	}
}
