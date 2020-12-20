//
//  PasswordViewController+Bind.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/20.
//

import Foundation
import RxSwift
import RxCocoa

extension PasswordViewController {
	func bindInputButton() {
		buttonsView.buttonEvent
			.observeOn(MainScheduler.instance)
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
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] state in
				self?.titleView.viberateAnimation(completion: {
					self?.titleView.clearPasswordField()
					self?.viewModel.clearPassword()
				})
			})
			.disposed(by: disposeBag)
	}

	func bindCorrectness() {
		viewModel.isCorrect
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] isCorrect in
				guard let self = self else { return }

				if isCorrect {
					// dissmiss and next step
				} else {
				}
			})
			.disposed(by: disposeBag)
	}
}
