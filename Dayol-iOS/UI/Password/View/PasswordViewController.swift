//
//  PasswordViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/12.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
	static let containerViewSpacing: CGFloat = 57.0
	static let closeButtonSize: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)
	
	static let closeButtonLeft: CGFloat = 8.0
	static let closeButtonTop: CGFloat = 8.0
}

private enum Strings {
	static let inputNewPassword: String = "새 암호를 입력해주세요"
	static let inputNewPasswordMore: String = "한 번 더 입력해주세요"
	static let inputPassword: String = "암호를 입력해주세요"
}

class PasswordViewController: UIViewController {
	let disposeBag = DisposeBag()
	let viewModel: PasswordViewModel
	//MARK: - UI

	let containerView: UIStackView = {
		let stackView = UIStackView()
		stackView.alignment = .center
		stackView.axis = .vertical
		stackView.spacing = Design.containerViewSpacing
		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

	let titleView: PasswordTitleView = {
		let view = PasswordTitleView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	let closeButton: UIButton = {
		let button = UIButton(frame: Design.closeButtonSize)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("X", for: .normal)
		button.setTitleColor(.black, for: .normal)

		return button
	}()

	let buttonsView: PasswordButtonsView = {
		let view = PasswordButtonsView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	//MARK: - Init()

    init(diaryColor: UIColor ,password: String) {
		self.viewModel = PasswordViewModel(password: password)
        self.titleView.diaryView.setCover(color: diaryColor)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
		initView()
    }

	//MARK: - Setup

	private func initView() {
		containerView.addArrangedSubview(titleView)
		containerView.addArrangedSubview(buttonsView)

		view.addSubview(containerView)
		view.addSubview(closeButton)
		view.backgroundColor = .white

		closeButton.addTarget(self, action: #selector(self.didTappedCloseButton(sender:)), for: .touchUpInside)

		setConstraint()
		bind()
	}

	//MARK: -Constraint

	private func setConstraint() {
		let layoutGuide = view.safeAreaLayoutGuide

		NSLayoutConstraint.activate([
			containerView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
			containerView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
			closeButton.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: Design.closeButtonTop),
			closeButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: Design.closeButtonTop)
		])
	}
}

// MARK: - Bind, Action

extension PasswordViewController {
	@objc
	private func didTappedCloseButton(sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	private func bind() {
		bindInputButton()
		bindAnimation()
		bindCorrectness()

		//TODO: 추후 로직에 따라 바뀔 수 있습니다.
		titleView.descText.onNext(Strings.inputNewPassword)
	}
}
