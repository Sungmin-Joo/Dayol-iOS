//
//  TextStyleView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit

private enum Design {
    static let optionViewHeight: CGFloat = 110
}

class TextStyleView: UIView {

    private let viewModel: TextStyleViewModel

    // MARK: - UI Property

    private let optionView: TextStyleOptionView = {
        let view = TextStyleOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fontView: TextStyleFontView = {
        let view = TextStyleFontView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: TextStyleViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initView()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TextStyleView {

    private func initView() {
        optionView.setTextStyleOption(alignment: viewModel.alignment,
                                      textSize: viewModel.textSize,
                                      additionalOptions: viewModel.additionalOptions,
                                      lineSpacing: viewModel.lineSpacing)
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

}
