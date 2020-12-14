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
	static let buttonFont: UIFont? = UIFont(name: "DXRMbxStd-B", size: 30.0)
	static let passwordImage: UIImage? = UIImage(named: "password_dayol")
	
	static let buttonHorizontalSpacing: CGFloat = 36.0
	static let buttonVerticalSpacing: CGFloat = 25.0

	static let buttonInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0.0, right: 0.0)
	static let buttonRadius: CGFloat = 29.0
	static let buttonBorderWidth: CGFloat = 2.0
	static let buttonBorderColor: CGColor = UIColor.black.cgColor
	static let buttonSize: CGSize = CGSize(width: 58, height: 58)

	static let deleteButtonImage: UIImage? = UIImage(named: "password_delete")
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

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initView()
	}

	required init?(coder: NSCoder) {
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
		let zeroButton = passwordButton(text: "0")
		let deleteButton = UIButton()

		stackView.axis = .horizontal
		stackView.spacing = Design.buttonHorizontalSpacing
		deleteButton.setImage(Design.deleteButtonImage, for: .normal)

		stackView.translatesAutoresizingMaskIntoConstraints = false
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		deleteButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			emptyView.widthAnchor.constraint(equalToConstant: Design.buttonSize.width),
			emptyView.heightAnchor.constraint(equalToConstant: Design.buttonSize.height),
			deleteButton.widthAnchor.constraint(equalToConstant: Design.buttonSize.width),
			deleteButton.heightAnchor.constraint(equalToConstant: Design.buttonSize.height)
		])

		stackView.addArrangedSubview(emptyView)
		stackView.addArrangedSubview(zeroButton)
		stackView.addArrangedSubview(deleteButton)

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

		texts.forEach { [weak self] text in
			guard let self = self else { return }
			stackView.addArrangedSubview(self.passwordButton(text: text))
		}

		return stackView
	}

	private func passwordButton(text: String) -> UIButton {
		let button = UIButton()

		button.setTitle(text, for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = Design.buttonFont

		button.contentEdgeInsets = Design.buttonInset
		button.layer.cornerRadius = Design.buttonRadius
		button.layer.borderWidth = Design.buttonBorderWidth
		button.layer.borderColor = Design.buttonBorderColor

		button.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			button.widthAnchor.constraint(equalToConstant: Design.buttonSize.width),
			button.heightAnchor.constraint(equalToConstant: Design.buttonSize.height)
		])

		button.rx.tap.bind { [weak self] in
			self?.didTappedNumberButton(button)
		}
		.disposed(by: disposeBag)

		return button
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
