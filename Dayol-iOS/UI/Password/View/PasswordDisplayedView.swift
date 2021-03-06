//
//  PasswordDisplayedView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/14.
//

import UIKit

private enum Design {
	static let passwordImage: UIImage? = UIImage(named: "password_dayol")

	static let innerCirclePaddings: CGFloat = 5.0
	static let innerCircleRadius: CGFloat = 10.0
	static let innerCircleBorderWidth: CGFloat = 2.0
	static let innerCircleBorderColor: UIColor = .black
	static let innerCircleSize: CGSize = CGSize(width: 20, height: 20)

	static let passwordDisplayViewSize: CGSize = CGSize(width: 30, height: 30)
}

class PasswordDisplayedView: UIView {
    private let scaleDownDuration: TimeInterval = 0.3
    private let scaleUpDudation: TimeInterval = 0.3
    private let inputtedScale: CGFloat = 1.3
    
	let circleView: UIView = {
		let view = UIView()
		view.layer.borderWidth = Design.innerCircleBorderWidth
		view.layer.borderColor = Design.innerCircleBorderColor.cgColor
		view.layer.cornerRadius = Design.innerCircleRadius
		view.layer.masksToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	let inputedImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = Design.passwordImage
        imageView.alpha = 0
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}()

	init() {
		super.init(frame: .zero)
		self.initView()
	}

	private override init(frame: CGRect) {
		super.init(frame: frame)
		self.initView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initView() {
		addSubview(circleView)
		addSubview(inputedImageView)
		setConstraint()
	}

	private func setConstraint() {
		NSLayoutConstraint.activate([
			heightAnchor.constraint(equalToConstant: Design.passwordDisplayViewSize.height),
			widthAnchor.constraint(equalToConstant: Design.passwordDisplayViewSize.width),

			circleView.topAnchor.constraint(equalTo: topAnchor, constant: Design.innerCirclePaddings),
			circleView.leftAnchor.constraint(equalTo: leftAnchor, constant: Design.innerCirclePaddings),
			circleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.innerCirclePaddings),
			circleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.innerCirclePaddings),

			inputedImageView.topAnchor.constraint(equalTo: topAnchor),
			inputedImageView.leftAnchor.constraint(equalTo: leftAnchor),
			inputedImageView.rightAnchor.constraint(equalTo: rightAnchor),
			inputedImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
    
    private func animateSclae(to scale: CGFloat, duration: TimeInterval, completion: (() -> Void)?) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        self.transform = .init(scaleX: scale, y: scale)
                       },
                       completion: { _ in
                        completion?()
                       }
        )
    }
}

extension PasswordDisplayedView {
    func setPassword() {
        inputedImageView.alpha = 1.0
        animateSclae(to: inputtedScale, duration: scaleUpDudation) { [weak self] in
            guard let self = self else { return }
            self.animateSclae(to: 1.0, duration: self.scaleDownDuration, completion: nil)
        }
    }
    
    func resetPassword() {
        inputedImageView.alpha = 0
    }
}
