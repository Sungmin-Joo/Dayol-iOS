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
    private let baseWidth: CGFloat = PaperOrientationConstant.size(orentantion: .portrait).width / CGFloat(7)

    init(viewModel: PaperScheduleLineViewModel, baseWidth: CGFloat) {
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
                let emptyView = UIView()
                emptyView.translatesAutoresizingMaskIntoConstraints = false
                emptyView.widthAnchor.constraint(equalToConstant: baseWidth * CGFloat(day)).isActive = true
                addArrangedSubview(emptyView)
            case .schedule(day: let day, name: let name, colorHex: let colorHex):
                let scheduleView = PaperScheduleView(scheduleName: name, color: UIColor(hex: colorHex) ?? .clear)
                scheduleView.translatesAutoresizingMaskIntoConstraints = false
                scheduleView.widthAnchor.constraint(equalToConstant: baseWidth * CGFloat(day)).isActive = true
                addArrangedSubview(scheduleView)
            }
        }
    }
}
