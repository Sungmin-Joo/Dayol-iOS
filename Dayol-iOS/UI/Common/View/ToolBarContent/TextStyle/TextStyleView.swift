//
//  TextStyleView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit
import Combine

private enum Design {
    static let optionViewHeight: CGFloat = 110
}

class TextStyleView: UIView {

    private var cancellable: [AnyCancellable] = []
    let attributesSubject: CurrentValueSubject<[NSAttributedString.Key: Any?], Never>
    var currentAttributes: [NSAttributedString.Key: Any?] {
        return attributesSubject.value
    }

    // MARK: - UI Property

    private lazy var optionView: TextStyleOptionView = {
        let view = TextStyleOptionView(attributes: currentAttributes)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fontView: TextStyleFontView = {
        let view = TextStyleFontView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(attributes: [NSAttributedString.Key: Any?]) {
        self.attributesSubject = CurrentValueSubject(attributes)
        super.init(frame: .zero)
        initView()
        setupConstraint()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

extension TextStyleView {

    private func initView() {
        backgroundColor = .gray100
        addSubview(optionView)
        addSubview(fontView)
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            optionView.heightAnchor.constraint(equalToConstant: Design.optionViewHeight),
            optionView.topAnchor.constraint(equalTo: topAnchor),
            optionView.leftAnchor.constraint(equalTo: leftAnchor),
            optionView.rightAnchor.constraint(equalTo: rightAnchor),

            fontView.topAnchor.constraint(equalTo: optionView.bottomAnchor),
            fontView.leftAnchor.constraint(equalTo: leftAnchor),
            fontView.rightAnchor.constraint(equalTo: rightAnchor),
            fontView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func bindEvent() {

        optionView.attributesSubject.sink { [weak self] attributes in
            self?.attributesSubject.send(attributes)
        }
        .store(in: &cancellable)

    }

}

extension TextStyleView {


}
