//
//  PasswordTitleView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/14.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
	static let passwordImage: UIImage? = UIImage(named: "password_dayol")
	static let inputFont: UIFont? = UIFont(name: "AppleSDGothicNeo-Bold", size: 19.0)
	static let passwordHoriaontalSpacing: CGFloat = 14.0
	static let passwordCount: Int = 4

	static let diaryWidth: CGFloat = 75.0
	static let diaryHegith: CGFloat = 96.0

	static let descLabelTop: CGFloat = 17.0
	static let stackTop: CGFloat = 27.0
}

class PasswordTitleView: UIView {
	enum InputState {
		case input
		case delete
	}

	let disposeBag = DisposeBag()
	let inputState = PublishSubject<PasswordTitleView.InputState>()
	let descText = PublishSubject<String>()

	var currentPasswordIndex = 0

	let diaryView: DiaryView = {
		let diaryView = DiaryView()
		diaryView.translatesAutoresizingMaskIntoConstraints = false

		return diaryView
	}()

	let descLabel: UILabel = {
		let label = UILabel()
		label.font = Design.inputFont
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Please, Input Your Password"
		label.sizeToFit()

		return label
	}()

	let passwordFieldStack: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = Design.passwordHoriaontalSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

	init() {
		super.init(frame: .zero)
		initView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initView() {
		for _ in 0..<Design.passwordCount {
			let passwordDisplayedView = PasswordDisplayedView()
			passwordFieldStack.addArrangedSubview(passwordDisplayedView)
		}
		addSubview(passwordFieldStack)
		addSubview(diaryView)
		addSubview(descLabel)

		setConstraint()
		bind()
	}

	private func setConstraint() {
		NSLayoutConstraint.activate([
			diaryView.heightAnchor.constraint(equalToConstant: Design.diaryHegith),
			diaryView.widthAnchor.constraint(equalToConstant: Design.diaryWidth),
			diaryView.topAnchor.constraint(equalTo: topAnchor),
			diaryView.centerXAnchor.constraint(equalTo: centerXAnchor),

			descLabel.topAnchor.constraint(equalTo: diaryView.bottomAnchor, constant: Design.descLabelTop),
			descLabel.leftAnchor.constraint(equalTo: leftAnchor),
			descLabel.rightAnchor.constraint(equalTo: rightAnchor),

			passwordFieldStack.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: Design.stackTop),
			passwordFieldStack.centerXAnchor.constraint(equalTo: centerXAnchor),
			passwordFieldStack.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}

	func clearPasswordField() {
		self.currentPasswordIndex = 0
		guard let fieldSubviews = self.passwordFieldStack.arrangedSubviews as? [PasswordDisplayedView] else { return }
		fieldSubviews.forEach { $0.inputedImageView.isHidden = true }
	}

	//출처 : https://stackoverflow.com/questions/3844557/uiview-shake-animation
	func viberateAnimation(completion: @escaping (() -> Void)) {
		// to set completionHandler
		// start Transaction
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			completion()
		}

		let midX = passwordFieldStack.center.x
		let midY = passwordFieldStack.center.y

		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.03
		animation.repeatCount = 4
		animation.autoreverses = true
		animation.fromValue = CGPoint(x: midX - 10, y: midY)
		animation.toValue = CGPoint(x: midX + 10, y: midY)
		passwordFieldStack.layer.add(animation, forKey: "position")

		// end Transaction
		CATransaction.commit()
	}
}

//MARK: -BIND

extension PasswordTitleView {
	private func bind() {
		inputState
			.bind(onNext: { [weak self] state in
				guard let self = self else { return }

				switch state {
				case .input:
					if self.currentPasswordIndex + 1 <= Design.passwordCount
					, let currentPasswordView = self.passwordFieldStack.arrangedSubviews[self.currentPasswordIndex] as? PasswordDisplayedView {
						currentPasswordView.inputedImageView.isHidden = false
						self.currentPasswordIndex += 1
                    }
				case .delete:
					if self.currentPasswordIndex - 1 >= 0
					, let currentPasswordView = self.passwordFieldStack.arrangedSubviews[self.currentPasswordIndex - 1] as? PasswordDisplayedView {
						self.currentPasswordIndex -= 1
						currentPasswordView.inputedImageView.isHidden = true
					}
				}
			})
			.disposed(by: disposeBag)

		descText
			.bind(onNext: { [weak self] text in
				guard let self = self else { return }

				self.descLabel.text = text
			})
			.disposed(by: disposeBag)
	}
}
