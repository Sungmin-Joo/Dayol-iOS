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
    
    var lineLeft: CGFloat {
        switch self {
        case .big: return 40
        case .medium: return 20
        case .small: return 5
        }
    }

	static let lineColor: UIColor = UIColor(decimalRed: 0, green: 0, blue: 0).withAlphaComponent(0.1)
}

class DiaryCoverView: DifferentEdgeSettableView {
	private let design: Design
    
	private let coverLineView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Design.lineColor

		return view
	}()

	init(type: DiaryType) {
        switch type {
        case .big: self.design = .big
        case .medium: self.design = .medium
        case .small: self.design = .small
        }
        super.init(topLeft: design.leftRadius,
                   topRight: design.rightRadius,
                   bottomLeft: design.leftRadius,
                   bottomRight: design.rightRadius)
		initView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initView() {
        addSubview(coverLineView)
		setConstraints()
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
            coverLineView.rightAnchor.constraint(equalTo: leftAnchor, constant: design.lineLeft),
            coverLineView.widthAnchor.constraint(equalToConstant: design.lineWidth),
			coverLineView.topAnchor.constraint(equalTo: topAnchor),
			coverLineView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
