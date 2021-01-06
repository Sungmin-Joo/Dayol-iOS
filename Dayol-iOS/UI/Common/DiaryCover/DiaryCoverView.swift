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
        case .big: return 32
		case .medium: return 16
		case .small: return 4
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
    static let coverLogo = UIImage(named: "dayolCoverLogo")
    static let coverLogoHeightRate: CGFloat = 172 / 720
    static let coverLogoWidthRate: CGFloat = 184 / 540
}

class DiaryCoverView: DifferentEdgeSettableView {
	private let design: Design
    
	private let coverLineView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Design.lineColor

		return view
	}()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Design.coverLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        return imageView
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
        addSubview(logoImageView)
        addSubview(coverLineView)
		setConstraints()
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
            coverLineView.rightAnchor.constraint(equalTo: leftAnchor, constant: design.lineLeft),
            coverLineView.widthAnchor.constraint(equalToConstant: design.lineWidth),
			coverLineView.topAnchor.constraint(equalTo: topAnchor),
			coverLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 9),
            logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Design.coverLogoHeightRate),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Design.coverLogoWidthRate)
		])
	}
}

extension DiaryCoverView {
    func setDayolLogoHidden(_ isHidden: Bool) {
        logoImageView.isHidden = isHidden
    }
}
