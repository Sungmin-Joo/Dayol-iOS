//
//  ScheduleDateDsiplayView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/10.
//

import UIKit

private enum Design {
    enum DateLabel {
        static let letterSpace: CGFloat = -0.26
        static let textColor = UIColor.gray800
        static let textFont = UIFont.appleRegular(size: 14)
    }

    enum HourLabel {
        static let letterSpace: CGFloat = -0.3
        static let textColor = UIColor.gray900
        static let textFont = UIFont.appleRegular(size: 16)
    }

    enum Size {
        static let stackWidth: CGFloat = 120
    }

    enum Margin {
        static let stackSpace: CGFloat = 3
    }
}

final class ScheduleDateDisplayView: UIView {
    // MARK: - UI Component

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Design.Margin.stackSpace

        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1

        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()

    // MARK: - Init

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

        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(timeLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Set

    func setDate(_ date: Date) {
        let dateString = DateType.schedule.dateToString(date)
        let timeString = DateType.time.dateToString(date)

        dateLabel.attributedText = NSAttributedString.build(text: dateString,
                                                            font: Design.DateLabel.textFont,
                                                            align: .natural,
                                                            letterSpacing: Design.DateLabel.letterSpace,
                                                            foregroundColor: Design.DateLabel.textColor)
        timeLabel.attributedText = NSAttributedString.build(text: timeString,
                                                            font: Design.HourLabel.textFont,
                                                            align: .natural,
                                                            letterSpacing: Design.HourLabel.letterSpace,
                                                            foregroundColor: Design.HourLabel.textColor)
        dateLabel.sizeToFit()
        timeLabel.sizeToFit()
    }
}
