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

	let diaryView: UIView = {
		let view = UIView()
		view.backgroundColor = .orange
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
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

	private override init(frame: CGRect) {
		super.init(frame: frame)
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
