//
//  PaperScheduleLineView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import UIKit

private enum Design {
    static let height: CGFloat = 13
}

final class PaperScheduleLineView: UIStackView {
    private let viewModel: PaperScheduleLineViewModel
    private let baseWidth: CGFloat

    init(viewModel: PaperScheduleLineViewModel, baseWidth: CGFloat) {
        self.baseWidth = baseWidth
        self.viewModel = viewModel
        super.init(frame: .zero)
        axis = .horizontal

        addSubviews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        viewModel.schedules.forEach { schedule in
            switch schedule {
            case .empty(day: let day):
                let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: baseWidth * CGFloat(day), height: Design.height))
                addArrangedSubview(emptyView)
            case .schedule(day: let day, name: let name, colorHex: let colorHex):
                let scheduleView = PaperScheduleView(scheduleName: name, color: UIColor(hex: colorHex) ?? .clear)
                scheduleView.frame.size = CGSize(width: baseWidth * CGFloat(day), height: Design.height)
                addArrangedSubview(scheduleView)
            }
        }
    }
}
