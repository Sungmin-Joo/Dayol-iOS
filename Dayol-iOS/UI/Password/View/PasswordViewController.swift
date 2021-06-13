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
    static let closeButtonImage: UIImage? = UIImage(named: "cancelButton")
}

private enum Strings {
	static let inputNewPassword: String = "새 암호를 입력해주세요"
	static let inputNewPasswordMore: String = "한 번 더 입력해주세요"
	static let inputPassword: String = "암호를 입력해주세요"
}

class PasswordViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: PasswordViewModel
    private let inputType: PasswordViewModel.InputType
    let didCreatePassword = PublishSubject<String>()
    let didPassedPassword = PublishSubject<String>()
    
	//MARK: - UI

    private let containerView: UIStackView = {
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

    private let closeButton: UIButton = {
		let button = UIButton(frame: Design.closeButtonSize)
		button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.closeButtonImage, for: .normal)

		return button
	}()

    let buttonsView: PasswordButtonsView = {
		let view = PasswordButtonsView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	//MARK: - Init()

    init(inputType: PasswordViewModel.InputType, diaryColor: PaletteColor ,password: String? = nil) {
        self.viewModel = PasswordViewModel(inputType: inputType, password: password)
        self.titleView.diaryView.setCover(color: diaryColor)
        self.inputType = inputType
		super.init(nibName: nil, bundle: nil)
    }

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
		initView()
        prepareViewModel()
    }
    
	//MARK: - Setup

    private func prepareViewModel() {
        switch inputType {
        case .check:
            viewModel.prepareCheckPassword()
        case .new:
            viewModel.prepareCreatePassword()
        }
    }
    
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

	//MARK: - Constraint

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

private extension PasswordViewController {
	@objc
    func didTappedCloseButton(sender: Any) {
		dismiss(animated: true, completion: nil)
	}

    func bind() {
		bindInputButton()
		bindAnimation()
		bindCorrectness()
        bindPreparePassword()
	}
}

private extension PasswordViewController {
    func bindInputButton() {
        buttonsView.buttonEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .input(number: let number):
                    self.titleView.inputState.onNext(.input)
                    self.viewModel.inputPassword(number: number)
                case .delete:
                    self.titleView.inputState.onNext(.delete)
                    self.viewModel.deletePassword()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindAnimation() {
        viewModel.shouldShowVibeAniamtion
            .observe(on: MainScheduler.instance)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] showAnimation in
                guard let self = self else { return }
                
                if showAnimation {
                    self.titleView.viberateAnimation(completion: {
                        self.titleView.clearPasswordField()
                        self.viewModel.clearPassword()
                    })
                }
            })
            .disposed(by: disposeBag)
    }

    func bindCorrectness() {
        viewModel.isCorrect
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isCorrect in
                guard let self = self else { return }
                let password = self.viewModel.inputtedPassword

                // TODO: 패스워드 모델 정해지면 수정
                //if isCorrect || viewModel.pass {
                self.dismiss(animated: true, completion: {
                    self.didPassedPassword.onNext(password)
                    self.didCreatePassword.onNext(password)
                })
                //}
            })
            .disposed(by: disposeBag)
    }
    
    func bindPreparePassword() {
        viewModel.shouldCheckPassword
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.titleView.descText.onNext(Strings.inputPassword)
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldCreatePassword
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.titleView.descText.onNext(Strings.inputNewPassword)
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldReInputPassword
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.titleView.descText.onNext(Strings.inputNewPasswordMore)
                self.titleView.clearPasswordField()
                self.viewModel.clearPassword()
            })
            .disposed(by: disposeBag)
    }
}

