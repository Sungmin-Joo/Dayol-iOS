//
//  DiaryLockerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

private enum Design {
    enum Standard {
        static let width: CGFloat = 140
        static let buttonLeftMargin: CGFloat = 30.0
        static let buttonRadius: CGFloat = 32.0
        static let rightRadius: CGFloat = 8.0
    }
    static let borderWidth: CGFloat = 2.0
	static let buttonColor: UIColor = .white
    static let buttonBorderColor: CGColor = UIColor.black.withAlphaComponent(0.1).cgColor
    static let lockImage = Assets.Image.DiaryCover.lock
}

class DiaryLockerView: DifferentEdgeSettableView {

	private let lockImageView: UIImageView = {
		let imageView = UIImageView()
        imageView.image = Design.lockImage
		return imageView
	}()

	private let buttonView: UIView = {
		let view = UIView()
        view.layer.borderWidth = Design.borderWidth
        view.layer.borderColor = Design.buttonBorderColor
        view.layer.masksToBounds = true
		view.backgroundColor = Design.buttonColor
		return view
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
        updateButtonView(ratio)
        updateView(ratio)
        // DifferentEdgeSettableView에서 radious 적용
        super.layoutSubviews()
    }

	private func initView() {
        addSubview(lockImageView)
        addSubview(buttonView)
        unlock()
    }

    private func updateButtonView(_ ratio: CGFloat) {
        let buttonWidth = round((Design.Standard.buttonRadius * 2) * ratio)
        [buttonView, lockImageView].forEach {
            $0.layer.cornerRadius = buttonWidth / 2.0
            $0.frame.size = CGSize(width: buttonWidth, height: buttonWidth)
            $0.center.y = frame.height / 2.0
            $0.frame.origin.x = Design.Standard.buttonLeftMargin * ratio
        }
    }

    private func updateView(_ ratio: CGFloat) {
        let leftRadius = frame.height / 2.0
        let rightRadius = Design.Standard.rightRadius * ratio

        setDifferentEdge(topLeft: leftRadius,
                         topRight: rightRadius,
                         bottomLeft: leftRadius,
                         bottomRight: rightRadius)
    }

}

extension DiaryLockerView {

    func lock() {
        lockImageView.isHidden = false
        buttonView.isHidden = true
    }

    func unlock() {
        lockImageView.isHidden = true
        buttonView.isHidden = false
    }

}
