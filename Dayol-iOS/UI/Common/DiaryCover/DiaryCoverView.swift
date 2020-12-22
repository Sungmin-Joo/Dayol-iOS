//
//  DiaryCoverView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

private enum Design {
	static func rightRadius(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 16
		case .medium: return 8
		case .small: return 2
		}
	}

	static func leftRadius(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 8
		case .medium: return 4
		case .small: return 1
		}
	}

	static func lineWidth(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 8
		case .medium: return 4
		case .small: return 2
		}
	}

	static func leftViewWidth(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 48
		case .medium: return 24
		case .small: return 6
		}
	}

	static func rightViewWidth(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 492
		case .medium: return 246
		case .small: return 246 / 4
		}
	}

	static let lineColor: UIColor = UIColor(decimalRed: 0, green: 0, blue: 0).withAlphaComponent(0.1)
}

class DiaryCoverView: UIView {
	let type: DiaryType

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

	private let coverLineView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Design.lineColor

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
		setRightView(backgroundColor: backgroundColor)
		setLeftView(backgroundColor: backgroundColor)
		setConstraints()
	}

	private func setRightView(backgroundColor: UIColor?) {
		rightView.backgroundColor = backgroundColor
		rightView.clipsToBounds = true
		rightView.layer.cornerRadius = Design.rightRadius(type: type)
		rightView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

		rightView.widthAnchor.constraint(equalToConstant: Design.rightViewWidth(type: type)).isActive = true
	}

	private func setLeftView(backgroundColor: UIColor?) {
		leftView.backgroundColor = backgroundColor
		leftView.clipsToBounds = true
		leftView.layer.cornerRadius = Design.leftRadius(type: type)
		leftView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
		leftView.addSubview(coverLineView)

		leftView.widthAnchor.constraint(equalToConstant: Design.leftViewWidth(type: type)).isActive = true
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
			stackView.leftAnchor.constraint(equalTo: leftAnchor),
			stackView.rightAnchor.constraint(equalTo: rightAnchor),
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

			coverLineView.rightAnchor.constraint(equalTo: leftView.rightAnchor),
			coverLineView.widthAnchor.constraint(equalToConstant: Design.lineWidth(type: type)),
			coverLineView.topAnchor.constraint(equalTo: leftView.topAnchor),
			coverLineView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor)
		])
	}
}
