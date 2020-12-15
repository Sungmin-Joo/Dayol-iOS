//
//  PasswordButtonsView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/14.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
	static let buttonSize: CGSize = CGSize(width: 58, height: 58)
	static let buttonHorizontalSpacing: CGFloat = 36.0
	static let buttonVerticalSpacing: CGFloat = 25.0
}

private enum Strings {
	static let buttonTitles: [[String]] = [
		["1", "2", "3"],
		["4", "5", "6"],
		["7", "8", "9"]
	]
}

class PasswordButtonsView: UIView {
	enum InputState {
		case input(number: Int)
		case delete
	}

	let buttonEvent = PublishSubject<PasswordButtonsView.InputState>()
	let disposeBag = DisposeBag()

	private let buttonVerticalStack: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.alignment = .center
		stackView.axis = .vertical
		stackView.spacing = Design.buttonVerticalSpacing

		return stackView
	}()

	init() {
		super.init(frame: .zero)
		self.initView()
	}

	private override init(frame: CGRect) {
		super.init(frame: frame)
		self.initView()
	}

	private required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initView() {
		Strings.buttonTitles.forEach { strings in
			buttonVerticalStack.addArrangedSubview(buttonHorizontalStack(texts: strings))
		}
		buttonVerticalStack.addArrangedSubview(buttonLastHorizontalStack())
		addSubview(buttonVerticalStack)
		setConstraint()
	}

	private func buttonLastHorizontalStack() -> UIStackView {
		let stackView = UIStackView()
		let emptyView = UIView()
		let zeroButton = PasswordButton(text: "0")
		let deleteButton = PasswordButton(isDelete: true)

		stackView.axis = .horizontal
		stackView.spacing = Design.buttonHorizontalSpacing

		stackView.translatesAutoresizingMaskIntoConstraints = false
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		deleteButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			emptyView.widthAnchor.constraint(equalToConstant: Design.buttonSize.width),
			emptyView.heightAnchor.constraint(equalToConstant: Design.buttonSize.height)
		])

		stackView.addArrangedSubview(emptyView)
		stackView.addArrangedSubview(zeroButton)
		stackView.addArrangedSubview(deleteButton)

		zeroButton.rx.tap.bind { [weak self] in
			self?.didTappedNumberButton(zeroButton)
		}
		.disposed(by: disposeBag)

		deleteButton.rx.tap.bind { [weak self] in
			self?.didTappedDeleteButton(deleteButton)
		}
		.disposed(by: disposeBag)

		return stackView
	}

	private func buttonHorizontalStack(texts: [String]) -> UIStackView {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = Design.buttonHorizontalSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false

		texts.forEach { text in
			let passwordButton = PasswordButton(text: text)
			passwordButton.rx.tap.bind { [weak self] in
				self?.didTappedNumberButton(passwordButton)
			}
			.disposed(by: disposeBag)
			stackView.addArrangedSubview(passwordButton)
		}

		return stackView
	}

	private func setConstraint() {
		NSLayoutConstraint.activate([
			buttonVerticalStack.topAnchor.constraint(equalTo: self.topAnchor),
			buttonVerticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			buttonVerticalStack.leftAnchor.constraint(equalTo: self.leftAnchor),
			buttonVerticalStack.rightAnchor.constraint(equalTo: self.rightAnchor)
		])
	}
}

//MARK: -Action

extension PasswordButtonsView {
	private func didTappedNumberButton(_ sender: UIButton) {
		guard let text = sender.titleLabel?.text, let number = Int(text) else { return }
		buttonEvent.onNext(.input(number: number))
	}

	private func didTappedDeleteButton(_ sender: UIButton) {
		buttonEvent.onNext(.delete)
	}
}
