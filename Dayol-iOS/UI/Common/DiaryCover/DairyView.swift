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

	var coverSize: CGSize {
		switch self {
		case .big:
			return CGSize(width: 540, height: 720)
		case .medium:
			return CGSize(width: 270, height: 360)
		case .small:
			return CGSize(width: 75, height: 96)
		}
	}
    
    var lockerSize: CGSize {
        switch self {
        case .big:
            return CGSize(width: 140, height: 120)
        case .medium:
            return CGSize(width: 70, height: 60)
        case .small:
            return CGSize(width: 70 / 4, height: 60 / 4)
        }
    }
}

private enum Design {
    case big
    case medium
    case small
    
    var coverSize: CGSize {
        switch self {
        case .big: return DiaryType.big.coverSize
        case .medium: return DiaryType.medium.coverSize
        case .small: return DiaryType.small.coverSize
        }
    }
    
    var lockerSize: CGSize {
        switch self {
        case .big: return DiaryType.big.lockerSize
        case .medium: return DiaryType.medium.lockerSize
        case .small: return DiaryType.small.lockerSize
        }
    }
    
	var coverLeft: CGFloat {
		switch self {
		case .big: return 16
		case .medium: return 8
		case .small: return 2
		}
    }
}

class DiaryView: UIView {
	private let design: Design
	private let coverView: DiaryCoverView
	private let lockerView: DiaryLockerView
	
	init(type: DiaryType, backgroundColor: UIColor) {
        switch type {
        case .big: self.design = .big
        case .medium: self.design = .medium
        case .small: self.design = .small
        }
		self.coverView = DiaryCoverView(type: type, backgroundColor: backgroundColor.withAlphaComponent(0.5))
		self.lockerView = DiaryLockerView(type: type, backgroundColor: backgroundColor.withAlphaComponent(0.9))
		super.init(frame: .zero)
		addSubview(coverView)
		addSubview(lockerView)
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        lockerView.translatesAutoresizingMaskIntoConstraints = false

		setConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
            coverView.widthAnchor.constraint(equalToConstant: design.coverSize.width),
            coverView.heightAnchor.constraint(equalToConstant: design.coverSize.height),
            
			coverView.topAnchor.constraint(equalTo: topAnchor),
			coverView.bottomAnchor.constraint(equalTo: bottomAnchor),
            coverView.rightAnchor.constraint(equalTo: rightAnchor, constant: -design.coverLeft),
			coverView.leftAnchor.constraint(equalTo: leftAnchor),

			lockerView.rightAnchor.constraint(equalTo: rightAnchor),
			lockerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lockerView.heightAnchor.constraint(equalToConstant: design.lockerSize.height),
            lockerView.widthAnchor.constraint(equalToConstant: design.lockerSize.width)
		])
	}
}
