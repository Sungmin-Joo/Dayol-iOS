//
//  ScheduleModalContentView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/09.
//

import UIKit

final class ScheduleModalContentView: UIView {
    // MARK: - Property

    private let scheduleType: ScheduleModalType

    private let scheduleTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let dateSelectView: UIView = {
        // week or month
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let colorSelectView: DefaultColorCollectionView = {
        // with header or noHeader
        let view = DefaultColorCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let addOtherPaperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let deleteScheduleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Init

    init(scheduleType: ScheduleModalType) {
        self.scheduleType = scheduleType
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
