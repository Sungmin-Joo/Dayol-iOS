//
//  PaperScheduleContrainerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import UIKit

private enum Design {
    static let scheduleViewHeight: CGFloat = 13
    static let scheduleViewSpace: CGFloat = 5
}

final class PaperScheduleContrainerView: UIStackView {
    private let maxScheduleCount: Int

    init(maxScheduleCount: Int) {
        self.maxScheduleCount = maxScheduleCount
        super.init(frame: .zero)
        axis = .vertical
        spacing = Design.scheduleViewSpace
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
