//
//  DiaryCoverView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

private enum Design {
    enum Standard {
        static let width: CGFloat = 540.0
        static let height: CGFloat = 720.0

        static let rightRadius: CGFloat = 32.0
        static let leftRadius: CGFloat = 8.0
        static let lineWidth: CGFloat = 8.0
        static let lineLeft: CGFloat = 40.0
    }

    static let lineColor: UIColor = UIColor(decimalRed: 0, green: 0, blue: 0).withAlphaComponent(0.1)
    static let coverLogo = UIImage(named: "dayolCoverLogo")
    static let coverLogoHeightRate: CGFloat = 172 / Standard.height
    static let coverLogoWidthRate: CGFloat = 184 / Standard.width
}

class DiaryCoverView: DifferentEdgeSettableView {

	private let coverLineView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleHeight]
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

	init() {
        super.init()
		initView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func layoutSubviews() {
        let ratio = frame.width / Design.Standard.width
        updateCoverRadius(ratio)
        relayoutCoverLineView(ratio)
        // DifferentEdgeSettableView에서 radious 적용
        super.layoutSubviews()
    }

	private func initView() {
        addSubview(logoImageView)
        addSubview(coverLineView)
		setConstraints()
	}

    private func relayoutCoverLineView(_ ratio: CGFloat) {
        coverLineView.frame.origin.x = Design.Standard.lineLeft * ratio
        coverLineView.frame.size.width = Design.Standard.lineWidth * ratio
    }

    private func updateCoverRadius(_ ratio: CGFloat) {
        let leftRadius = Design.Standard.leftRadius * ratio
        let rightRadius = Design.Standard.rightRadius * ratio

        setDifferentEdge(topLeft: leftRadius,
                         topRight: rightRadius,
                         bottomLeft: leftRadius,
                         bottomRight: rightRadius)
    }

	private func setConstraints() {
		NSLayoutConstraint.activate([
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
