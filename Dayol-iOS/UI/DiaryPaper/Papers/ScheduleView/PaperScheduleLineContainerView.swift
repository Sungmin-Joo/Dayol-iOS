//
//  PaperScheduleLineContainerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import UIKit

private enum Design {
    static let scheduleViewSpace: CGFloat = 5
    static let scheduleViewHeight: CGFloat = 13
}

final class PaperScheduleLineContainerView: UIStackView {
    private var maxScheduleCount: Int = 0
    private var baseWidth: CGFloat = 0

    init() {
        super.init(frame: .zero)
        axis = .vertical
        spacing = Design.scheduleViewSpace
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(scheduleCount: Int, widthPerSchedule: CGFloat, schedules: [PaperScheduler]) {
        self.maxScheduleCount = scheduleCount
        self.baseWidth = widthPerSchedule

        let scheduleLine = makeScheduleLine(schedules: schedules)
        addArrangedSubview(scheduleLine)

        NSLayoutConstraint.activate([
            scheduleLine.heightAnchor.constraint(equalToConstant: Design.scheduleViewHeight)
        ])
    }

    private func makeScheduleLine(schedules: [PaperScheduler]) -> PaperScheduleLineView {
        let viewModel = PaperScheduleLineViewModel(scheduleModels: schedules, firstDateOfWeek: .now)
        let lineView = PaperScheduleLineView(viewModel: viewModel, baseWidth: baseWidth)
        return lineView
    }
}
