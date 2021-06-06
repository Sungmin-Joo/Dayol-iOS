//
//  PencilSettingView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/18.
//

import UIKit
import Combine

private enum Design {
    static let backgroundColor: UIColor = .gray100
    static let pencilTypeSettingViewHeight: CGFloat = 35.0
    static let pencilAlphaSettingViewHeight: CGFloat = 30.0
    static let pencilAlphaSettingViewWidth: CGFloat = 275.0
    static let stackViewTopMargin: CGFloat = 16.0
    static let stackViewBottomMargin: CGFloat = 25.0
}

class PencilSettingView: UIView {
    typealias PencilInfo = (color: UIColor, pencilType: PencilTypeSettingView.PencilType)

    var currentPencilInfo: PencilInfo
    private var cancellable: [AnyCancellable] = []

    // MARK: UI Property

    private let pencilTypeSettingView: PencilTypeSettingView = {
        let view = PencilTypeSettingView()
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

    init(currentColor: UIColor, pencilType: PencilTypeSettingView.PencilType) {
        pencilTypeSettingView.pencilTypeSubject.send(pencilType)
        colorSettingView.set(color: currentColor)
        pencilAlphaSettingView.set(color: currentColor)

        self.currentPencilInfo = (color: currentColor, pencilType: pencilType)
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
        backgroundColor = Design.backgroundColor
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

            contentStackView.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: Design.stackViewTopMargin),
            contentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -Design.stackViewBottomMargin),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func bindEvent() {

        pencilTypeSettingView.pencilTypeSubject.sink { [weak self] pencilType in
            self?.currentPencilInfo.pencilType = pencilType
        }
        .store(in: &cancellable)

        colorSettingView.colorSubject.sink { [weak self] color in
            self?.currentPencilInfo.color = color
            self?.pencilAlphaSettingView.set(color: color)
        }
        .store(in: &cancellable)

    }

}
