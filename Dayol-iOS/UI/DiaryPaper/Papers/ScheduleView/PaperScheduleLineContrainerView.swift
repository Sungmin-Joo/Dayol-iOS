//
//  PaperScheduleLineContrainerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import UIKit

private enum Design {
    static let scheduleViewSpace: CGFloat = 5
    static let scheduleViewHeight: CGFloat = 13
}

final class PaperScheduleLineContrainerView: UIStackView {
    private let maxScheduleCount: Int
    private let baseWidth: CGFloat

    init(maxScheduleCount: Int, baseWidth: CGFloat) {
        self.baseWidth = baseWidth
        self.maxScheduleCount = maxScheduleCount
        super.init(frame: .zero)
        axis = .vertical
        spacing = Design.scheduleViewSpace
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
