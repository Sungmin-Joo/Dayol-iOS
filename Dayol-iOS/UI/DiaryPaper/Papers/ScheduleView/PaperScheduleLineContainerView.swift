//
//  PaperScheduleLineContainerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import UIKit

enum ScheduleLineStyle {
    case month(paper: Paper.PaperOrientation)
    case week(paper: Paper.PaperOrientation)
}

private enum Design {
    static let scheduleViewSpace: CGFloat = 5
    static let scheduleViewHeight: CGFloat = 13
}

final class PaperScheduleLineContainerView: UIStackView {
    private var maxScheduleCount: Int = 0
    private var baseWidth: CGFloat = 0
    private let lineType: ScheduleLineStyle

    init(lineType: ScheduleLineStyle) {
        self.lineType = lineType
        super.init(frame: .zero)
        axis = .vertical
        spacing = Design.scheduleViewSpace
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(scheduleCount: Int, widthPerSchedule: CGFloat, schedules: [PaperScheduler], firstDateOfWeek: Date) {
        self.maxScheduleCount = scheduleCount
        self.baseWidth = widthPerSchedule
        PaperScheduleStoreManager.shared.set(schedules: schedules)

        for _ in 0..<maxScheduleCount {
            let scheduleLine = makeScheduleLine(schedules: PaperScheduleStoreManager.shared.schedules, firstDateOfWeek: firstDateOfWeek)
            addArrangedSubview(scheduleLine)

            NSLayoutConstraint.activate([
                scheduleLine.heightAnchor.constraint(equalToConstant: Design.scheduleViewHeight)
            ])
        }
    }

    private func makeScheduleLine(schedules: [PaperScheduler], firstDateOfWeek: Date) -> PaperScheduleLineView {
        let viewModel = PaperScheduleLineViewModel(scheduleModels: schedules, firstDateOfWeek: firstDateOfWeek, lineType: lineType)
        let lineView = PaperScheduleLineView(viewModel: viewModel, baseWidth: baseWidth)
        return lineView
    }
}
