//
//  DiaryLockerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

private enum Design {
	static func lockerHeight(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 120
		case .medium: return 60
		case .small: return 15
		}
	}

	static func buttonInset(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 30
		case .medium: return 15
		case .small: return 15 / 4
		}
	}

	static func buttonWidth(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 4.0
		case .medium: return 2.0
		case .small: return 0.5
		}
	}

	static func buttonRadius(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 32
		case .medium: return 16
		case .small: return 4
		}
	}

	static func rightRadius(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 8
		case .medium: return 4
		case .small: return 1
		}
	}

	static func leftRadius(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 60
		case .medium: return 30
		case .small: return 30 / 4
		}
	}

	static func leftViewWidth(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 120
		case .medium: return 60
		case .small: return 15
		}
	}

	static func rightViewWidth(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 20
		case .medium: return 10
		case .small: return 10 / 4
		}
	}

	static let buttonColor: UIColor = .white
	static let buttonBorderColor: CGColor = UIColor(decimalRed: 0, green: 0, blue: 0).withAlphaComponent(0.1).cgColor
}

class DiaryLockerView: UIView {
	private let type: DiaryType

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
		self.type = type
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
		leftView.layer.cornerRadius = Design.leftRadius(type: type)
		leftView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]

		leftView.widthAnchor.constraint(equalToConstant: Design.leftViewWidth(type: type)).isActive = true
	}

	private func setRightView(backgroundColor: UIColor?) {
		rightView.backgroundColor = backgroundColor
		rightView.clipsToBounds = true
		rightView.layer.cornerRadius = Design.rightRadius(type: type)
		rightView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

		rightView.widthAnchor.constraint(equalToConstant: Design.rightViewWidth(type: type)).isActive = true
	}

	private func setButtonView() {
		buttonView.layer.borderWidth = Design.buttonWidth(type: type)
		buttonView.layer.borderColor = Design.buttonBorderColor
		buttonView.layer.cornerRadius = Design.buttonRadius(type: type)
		buttonView.layer.masksToBounds = true
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.leftAnchor.constraint(equalTo: leftAnchor),
			stackView.rightAnchor.constraint(equalTo: rightAnchor),

			lockImage.topAnchor.constraint(equalTo: topAnchor, constant: Design.buttonInset(type: type)),
			lockImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.buttonInset(type: type)),
			lockImage.leftAnchor.constraint(equalTo: leftAnchor, constant: Design.buttonInset(type: type)),
			lockImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.buttonInset(type: type)),

			buttonView.topAnchor.constraint(equalTo: topAnchor, constant: Design.buttonInset(type: type)),
			buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.buttonInset(type: type)),
			buttonView.leftAnchor.constraint(equalTo: leftAnchor, constant: Design.buttonInset(type: type)),
			buttonView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.buttonInset(type: type))
		])
	}
}
