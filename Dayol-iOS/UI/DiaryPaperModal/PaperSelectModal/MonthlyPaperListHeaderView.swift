//
//  PaperSelectHeaderView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/05.
//

import UIKit

final class MonthlyPaperListHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubViewPinEdge(titleLabel)
    }
}
