//
//  PencilSettingView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/18.
//

import UIKit
import Combine

private enum Design {
    static let pencilTypeSettingViewHeight: CGFloat = 55.0
    static let pencilAlphaSettingViewHeight: CGFloat = 30.0
    static let pencilAlphaSettingViewWidth: CGFloat = 275.0
}

class PencilSettingView: UIView {

    let colorSubject: CurrentValueSubject<UIColor, Never>
    private var cancellable: [AnyCancellable] = []

    // MARK: UI Property

    private let pencilTypeSettingView: PencilTypeSettingView = {
        let view = PencilTypeSettingView(type: .pen)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let colorSettingView: ColorSettingView = {
        let view = ColorSettingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let pencilAlphaSettingView: PencilAlphaSettingView = {
        let view = PencilAlphaSettingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(currentColor: UIColor) {
        // TODO: 현재 pencil 상태를 가져와서 세팅해주는 로직 추가
        self.colorSubject = CurrentValueSubject<UIColor, Never>(currentColor)
        super.init(frame: .zero)
        initView()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PencilSettingView {

    private func initView() {
        contentStackView.addArrangedSubview(pencilTypeSettingView)
        contentStackView.addArrangedSubview(colorSettingView)
        contentStackView.addArrangedSubview(pencilAlphaSettingView)
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pencilTypeSettingView.heightAnchor.constraint(equalToConstant: Design.pencilTypeSettingViewHeight),
            pencilTypeSettingView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),

            colorSettingView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),

            pencilAlphaSettingView.widthAnchor.constraint(equalToConstant: Design.pencilAlphaSettingViewWidth),
            pencilAlphaSettingView.heightAnchor.constraint(equalToConstant: Design.pencilAlphaSettingViewHeight),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func bindEvent() {
        colorSettingView.colorSubject.sink { [weak self] color in
            self?.pencilAlphaSettingView.set(color: color)
        }
        .store(in: &cancellable)

        colorSubject.sink { [weak self] color in
            self?.pencilAlphaSettingView.set(color: color)
            self?.colorSettingView.set(color: color)
        }
        .store(in: &cancellable)
    }

}
