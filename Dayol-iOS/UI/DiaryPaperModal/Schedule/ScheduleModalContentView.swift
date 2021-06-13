//
//  ScheduleModalContentView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/09.
//

import UIKit

private enum Design {
    enum Size {
        static let textFieldWidth: CGFloat = 331
        static let textFieldHeight: CGFloat = 31
        static let dateSelectHeight: CGFloat = 23
        static let deleteButtonHeight: CGFloat = 41
    }

    enum Margin {
        static let contentTextFieldSpace: CGFloat = 24
        static let textFieldDateSelectSpace: CGFloat = 36
        static let dateSelectColorSelectSpace: CGFloat = 36
        static let colorSelectBottomSpace: CGFloat = 16
    }

    enum Color {
        static let buttonTextColor: UIColor = .red
    }
}

private enum Text: String {
    case deleteSchedule = "이 일정 삭제"
}

final class ScheduleModalContentView: UIView {
    // MARK: - Property

    private let scheduleType: ScheduleModalType

    private let scheduleTextField: ScheduleTextFieldView = {
        let view = ScheduleTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let dateSelectView: ScheduleDateSelectView = {
        // week or month
        let view = ScheduleDateSelectView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let colorSelectView: ScheduleColorSelectView = {
        // with header or noHeader
        let view = ScheduleColorSelectView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let addOtherPaperView: ScheduleCheckView = {
        let view = ScheduleCheckView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let deleteScheduleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Design.Color.buttonTextColor, for: .normal)
        button.setTitle(Text.deleteSchedule.rawValue, for: .normal)

        return button
    }()

    // MARK: - Init

    init(scheduleType: ScheduleModalType) {
        self.scheduleType = scheduleType
        super.init(frame: .zero)
        setupViews()
        setupConstrains()

        dateSelectView.setDate(start: Date.now, end: Date.now)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(scheduleTextField)
        addSubview(dateSelectView)
        addSubview(colorSelectView)
        addSubview(addOtherPaperView)
        addSubview(deleteScheduleButton)

        setupBottomView()
    }

    private func setupBottomView() {
        switch scheduleType {
        case .display:
            addOtherPaperView.isHidden = true
        case .monthly:
            deleteScheduleButton.isHidden = true
            addOtherPaperView.setLabel(checkType: .weekly)
        case .weekly:
            deleteScheduleButton.isHidden = true
            addOtherPaperView.setLabel(checkType: .monthly)
        }
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            scheduleTextField.heightAnchor.constraint(equalToConstant: Design.Size.textFieldHeight),
            scheduleTextField.topAnchor.constraint(equalTo: topAnchor, constant: Design.Margin.contentTextFieldSpace),
            scheduleTextField.widthAnchor.constraint(equalToConstant: Design.Size.textFieldWidth),
            scheduleTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            dateSelectView.topAnchor.constraint(equalTo: scheduleTextField.bottomAnchor, constant: Design.Margin.textFieldDateSelectSpace),
            dateSelectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateSelectView.trailingAnchor.constraint(equalTo: trailingAnchor),

            colorSelectView.topAnchor.constraint(equalTo: dateSelectView.bottomAnchor, constant: Design.Margin.dateSelectColorSelectSpace),
            colorSelectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorSelectView.trailingAnchor.constraint(equalTo: trailingAnchor),

            addOtherPaperView.topAnchor.constraint(equalTo: colorSelectView.bottomAnchor, constant: Design.Margin.colorSelectBottomSpace),
            addOtherPaperView.centerXAnchor.constraint(equalTo: centerXAnchor),
            addOtherPaperView.heightAnchor.constraint(equalToConstant: Design.Size.deleteButtonHeight),

            deleteScheduleButton.topAnchor.constraint(equalTo: colorSelectView.bottomAnchor, constant: Design.Margin.colorSelectBottomSpace),
            deleteScheduleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            deleteScheduleButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteScheduleButton.heightAnchor.constraint(equalToConstant: Design.Size.deleteButtonHeight)
        ])
    }
}
