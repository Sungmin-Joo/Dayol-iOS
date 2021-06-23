//
//  TextStyleView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit
import Combine
import RxSwift

private enum Design {
    static let optionViewHeight: CGFloat = 110
}

class TextStyleView: UIView {

    private var cancellable: [AnyCancellable] = []
    private let disposeBag = DisposeBag()
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

    private let fontView: TextStyleFontView

    init(attributes: [NSAttributedString.Key: Any?]) {
        self.attributesSubject = CurrentValueSubject(attributes)

        if let font = attributes[.font] as? UIFont {
            self.fontView = TextStyleFontView(currentFontName: font.fontName)
        } else {
            self.fontView = TextStyleFontView(currentFontName: nil)
        }

        super.init(frame: .zero)
        initView()
        setupConstraint()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

extension TextStyleView {

    private func initView() {
        fontView.translatesAutoresizingMaskIntoConstraints = false

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

        fontView.viewModel.currentFontSubject
            .subscribe(onNext: { [weak self] customFont in
                self?.configureCustomFont(customFont)
            })
            .disposed(by: disposeBag)

    }

    private func configureCustomFont(_ customFont: TextStyleFontViewModel.Font) {
        let defaultFont = DYFlexibleTextField.DefaultOption.defaultFont

        var copiedAttributes = currentAttributes

        let font = copiedAttributes[.font] as? UIFont ?? defaultFont
        let isBoldFont = font.isBold
        let size = font.pointSize


        var newFont: UIFont?
        if customFont == .system {
            if isBoldFont {
                newFont = .systemFont(ofSize: size, weight: .bold)
            } else {
                newFont = .systemFont(ofSize: size)
            }

        } else {
            newFont = UIFont(name: customFont.rawValue, size: size)

            if isBoldFont {
                newFont = newFont?.toBoldFont
            }
        }

        copiedAttributes[.font] = newFont
        optionView.updateAttributes(copiedAttributes)
    }

}
