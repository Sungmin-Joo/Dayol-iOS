//
//  DairyView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

enum DiaryType {
	case big // For iPad
	case medium
	case small

	var size: CGSize {
		switch self {
		case .big:
			return CGSize(width: 540, height: 720)
		case .medium:
			return CGSize(width: 270, height: 360)
		case .small:
			return CGSize(width: 75, height: 96)
		}
	}
}

private enum Design {
	static func coverLeft(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 16
		case .medium: return 8
		case .small: return 2
		}
	}

	static func lockerHeight(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 120
		case .medium: return 60
		case .small: return 15
		}
	}

	static func lockerWidth(type: DiaryType) -> CGFloat {
		switch type {
		case .big: return 140
		case .medium: return 70
		case .small: return 70 / 4
		}
	}
}

class DiaryView: UIView {
	private let type: DiaryType
	private let coverView: DiaryCoverView
	private let lockerView: DiaryLockerView
	
	init(type: DiaryType, backgroundColor: UIColor) {
		self.type = type
		self.coverView = DiaryCoverView(type: type, backgroundColor: backgroundColor.withAlphaComponent(0.5))
		self.lockerView = DiaryLockerView(type: type, backgroundColor: backgroundColor.withAlphaComponent(0.9))
		super.init(frame: .zero)
		initView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initView() {
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(coverView)
		addSubview(lockerView)

		setConstraints()
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
			coverView.topAnchor.constraint(equalTo: topAnchor),
			coverView.bottomAnchor.constraint(equalTo: bottomAnchor),
			coverView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.coverLeft(type: type)),
			coverView.leftAnchor.constraint(equalTo: leftAnchor),

			lockerView.rightAnchor.constraint(equalTo: rightAnchor),
			lockerView.centerYAnchor.constraint(equalTo: centerYAnchor),
			lockerView.heightAnchor.constraint(equalToConstant: Design.lockerHeight(type: type)),
			lockerView.widthAnchor.constraint(equalToConstant: Design.lockerWidth(type: type))
		])
	}
}
