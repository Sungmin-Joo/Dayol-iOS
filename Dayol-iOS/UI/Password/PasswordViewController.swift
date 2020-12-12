//
//  PasswordViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/12.
//

import UIKit

private enum Design {
	static let passwordImage: UIImage? = UIImage(named: "password_dayol")
	static let inputFont: UIFont? = UIFont(name: "AppleSDGothicNeo-Bold", size: 19.0)
	static let buttonFont: UIFont? = UIFont(name: "DXRMbxStd-B", size: 30.0)

	static let passwordHoriaontalSpacing: CGFloat = 14.0
	static let buttonHorizontalSpacing: CGFloat = 36.0
	static let buttonVerticalSpacing: CGFloat = 25.0

	static let buttonInset: UIEdgeInsets = UIEdgeInsets(top: 14.0, left: 24.0, bottom: 14.0, right: 21.0)
	static let buttonRadius: CGFloat = 29.0
	static let buttonBorderWidth: CGFloat = 2.0
	static let buttonBorderColor: CGColor = UIColor.black.cgColor
	static let buttonSize: CGSize = CGSize(width: 58, height: 58)

	static let stackTop: CGFloat = 319.0
	static let stackBottom: CGFloat = 41.0
	static let stackLeft: CGFloat = 64.5
	static let stackRight: CGFloat = 64.5
}

private enum Strings {
	static let inputNewPassword: String = "새 암호를 입력해주세요"
	static let inputNewPasswordMore: String = "한 번 더 입력해주세요"
	static let inputPassword: String = "함호를 입력해주세요"
	static let buttonTitles: [[String]] = [
		["1", "2", "3"],
		["4", "5", "6"],
		["7", "8", "9"],
		["0"]
	]
}

class PasswordViewController: UIViewController {
	let buttonVerticalStack: UIStackView = {
		let stackView = UIStackView()
		stackView.alignment = .center
		stackView.axis = .vertical
		stackView.spacing = Design.buttonVerticalSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		initView()
    }

	private func initView() {
		Strings.buttonTitles.forEach { titles in
			buttonVerticalStack.addArrangedSubview(buttonHorizontalStack(texts: titles))
		}
		view.addSubview(buttonVerticalStack)
		view.backgroundColor = .white
		setConstraint()
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

		button.layer.cornerRadius = Design.buttonRadius
		button.layer.borderWidth = Design.buttonBorderWidth
		button.layer.borderColor = Design.buttonBorderColor

		button.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			button.widthAnchor.constraint(equalToConstant: Design.buttonSize.width),
			button.heightAnchor.constraint(equalToConstant: Design.buttonSize.height)
		])

		return button
	}

	private func setConstraint() {
		let layoutGuide = view.safeAreaLayoutGuide

		NSLayoutConstraint.activate([
			buttonVerticalStack.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -Design.stackBottom),
			buttonVerticalStack.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: Design.stackLeft),
			buttonVerticalStack.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -Design.stackRight),
		])
	}
}
