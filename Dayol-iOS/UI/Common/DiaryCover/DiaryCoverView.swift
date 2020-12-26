//
//  DiaryCoverView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

private enum Design {
    case big
    case medium
    case small
    
    var rightRadius: CGFloat {
		switch self {
        case .big: return 16
		case .medium: return 8
		case .small: return 2
		}
	}

    var leftRadius: CGFloat {
		switch self {
		case .big: return 8
		case .medium: return 4
		case .small: return 1
		}
	}

    var lineWidth: CGFloat {
		switch self {
		case .big: return 8
		case .medium: return 4
		case .small: return 2
		}
	}

    var leftViewWidth: CGFloat {
		switch self {
		case .big: return 48
		case .medium: return 24
		case .small: return 6
		}
	}

    var rightViewWidth: CGFloat {
		switch self {
		case .big: return 492
		case .medium: return 246
		case .small: return 246 / 4
		}
	}

	static let lineColor: UIColor = UIColor(decimalRed: 0, green: 0, blue: 0).withAlphaComponent(0.1)
}

class DiaryCoverView: UIView {
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

	private let coverLineView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Design.lineColor

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
		setRightView(backgroundColor: backgroundColor)
		setLeftView(backgroundColor: backgroundColor)
		setConstraints()
	}

	private func setRightView(backgroundColor: UIColor?) {
		rightView.backgroundColor = backgroundColor
		rightView.clipsToBounds = true
        rightView.layer.cornerRadius = design.rightRadius
		rightView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
	}

	private func setLeftView(backgroundColor: UIColor?) {
		leftView.backgroundColor = backgroundColor
		leftView.clipsToBounds = true
		leftView.layer.cornerRadius = design.leftRadius
		leftView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
		leftView.addSubview(coverLineView)
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
            rightView.widthAnchor.constraint(equalToConstant: design.rightViewWidth),
            leftView.widthAnchor.constraint(equalToConstant: design.leftViewWidth),
            
			stackView.leftAnchor.constraint(equalTo: leftAnchor),
			stackView.rightAnchor.constraint(equalTo: rightAnchor),
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

			coverLineView.rightAnchor.constraint(equalTo: leftView.rightAnchor),
            coverLineView.widthAnchor.constraint(equalToConstant: design.lineWidth),
			coverLineView.topAnchor.constraint(equalTo: leftView.topAnchor),
			coverLineView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor)
		])
	}
}
