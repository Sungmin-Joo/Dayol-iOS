//
//  PaperScheduleView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import UIKit

private enum Design {
    static let font = UIFont.appleRegular(size: 11)
    static let letterSpace: CGFloat = -0.5
    static let labelLeading: CGFloat = 3.0
}

final class PaperScheduleView: UIView {
    private let scheduleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    init(scheduleName: String, color: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = color
        addSubviews()
        setName(scheduleName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(scheduleNameLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scheduleNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.labelLeading),
            scheduleNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setName(_ name: String) {
        scheduleNameLabel.attributedText = NSAttributedString.build(text: name, font: Design.font, align: .natural, letterSpacing: Design.letterSpace, foregroundColor: .white)
        scheduleNameLabel.sizeToFit()
    }
}
