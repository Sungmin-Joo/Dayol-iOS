//
//  ScheduleDateSelectView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/10.
//

import UIKit
import RxSwift

private enum Design {
    enum Size {
        static let arrowImageSize: CGSize = .init(width: 13, height: 32)
    }

    enum Margin {
        static let leftDateArrowSpace: CGFloat = 22
        static let rightDateArrowSpace: CGFloat = 32
    }

    enum Image {
        static let arrowImage = UIImage(named: "schedule_arrow")
    }
}

final class ScheduleDateSelectView: UIView {
    private let disposeBag = DisposeBag()

    // MARK: - UI Component

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let leftDisplayView: ScheduleDateDisplayView = {
        let displayView = ScheduleDateDisplayView()
        displayView.translatesAutoresizingMaskIntoConstraints = false

        return displayView
    }()

    private let rightDisplayView: ScheduleDateDisplayView = {
        let displayView = ScheduleDateDisplayView()
        displayView.translatesAutoresizingMaskIntoConstraints = false

        return displayView
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Design.Image.arrowImage

        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        addSubview(stackView)

        stackView.addArrangedSubview(leftDisplayView)
        stackView.addArrangedSubview(arrowImageView)
        stackView.addArrangedSubview(rightDisplayView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            arrowImageView.widthAnchor.constraint(equalToConstant: Design.Size.arrowImageSize.width),
            arrowImageView.heightAnchor.constraint(equalToConstant: Design.Size.arrowImageSize.height)
        ])

        stackView.setCustomSpacing(Design.Margin.leftDateArrowSpace, after: leftDisplayView)
        stackView.setCustomSpacing(Design.Margin.rightDateArrowSpace, after: arrowImageView)
    }

    func setDate(start: Date, end: Date) {
        leftDisplayView.setDate(start)
        rightDisplayView.setDate(end)

        leftDisplayView.layoutIfNeeded()
        rightDisplayView.layoutIfNeeded()
    }
}
