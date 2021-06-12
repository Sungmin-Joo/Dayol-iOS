//
//  ScheduleColorSelectView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/10.
//

import UIKit

private enum Design {
    enum View {
        static let underLineColor: UIColor = .gray200
    }

    enum Size {
        static let underLineHeight: CGFloat = 1
        static let colorSelectHeight: CGFloat = 24
    }

    enum Margin {
        static let colorUnderLineSpace: CGFloat = 20
    }
}

final class ScheduleColorSelectView: UIView {
    private let colorSelectView: DefaultColorCollectionView = {
        let colorSelectView = DefaultColorCollectionView()
        let colorSet: [DiaryCoverColor] = [
            .DYRed,
            .DYOrange,
            .DYYellow,
            .DYGreen,
            .DYMint,
            .DYBlue,
            .DYPurple
        ]
        colorSelectView.translatesAutoresizingMaskIntoConstraints = false
        colorSelectView.showHeader = true
        colorSelectView.colors = colorSet
        colorSelectView.backgroundColor = .white

        return colorSelectView
    }()

    private let underLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    init() {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(colorSelectView)
        addSubview(underLineView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorSelectView.heightAnchor.constraint(equalToConstant: Design.Size.colorSelectHeight),
            colorSelectView.topAnchor.constraint(equalTo: topAnchor),
            colorSelectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorSelectView.trailingAnchor.constraint(equalTo: trailingAnchor),

            underLineView.topAnchor.constraint(equalTo: colorSelectView.bottomAnchor, constant: Design.Margin.colorUnderLineSpace),
            underLineView.heightAnchor.constraint(equalToConstant: Design.Size.underLineHeight),
            underLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underLineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
