//
//  DatePickerHeaderView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/05/27.
//

import UIKit
import RxSwift
import RxCocoa

final class DatePickerHeaderView: UIView {
    private let disposeBag = DisposeBag()

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()

    let didTappedConfirmButton = PublishSubject<Void>()

    init() {
        super.init(frame: .zero)
        initView()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        addSubview(confirmButton)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: topAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bind() {
        confirmButton.rx.tap
            .bind { [weak self] in
                self?.didTappedConfirmButton.onNext(())
            }
            .disposed(by: disposeBag)
    }
}
