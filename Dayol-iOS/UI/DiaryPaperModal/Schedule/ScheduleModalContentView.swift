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
        let view = ScheduleCheckView(checkType: .monthly)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let deleteScheduleView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        return view
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
        addSubview(deleteScheduleView)
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

            deleteScheduleView.topAnchor.constraint(equalTo: colorSelectView.bottomAnchor, constant: Design.Margin.colorSelectBottomSpace),
            deleteScheduleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            deleteScheduleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteScheduleView.heightAnchor.constraint(equalToConstant: Design.Size.deleteButtonHeight)
        ])
    }
}
