//
//  MonthlyCalendarCollectionView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/25.
//

import UIKit

private enum Design {
    static let dayFont = UIFont.systemFont(ofSize: 11, weight: .bold)
    static let sundayColor = UIColor(decimalRed: 211, green: 27, blue: 27)
    static let saturdayColor = UIColor(decimalRed: 43, green: 81, blue: 206)
    static let dayColor: UIColor = .black
    static let dayLetterSpace: CGFloat = -0.42
    static let weekDayHeight: CGFloat = 20
}

class MonthlyCalendarCollectionView: UIView {
    private let weekDayView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private let dayLabels: [UILabel] = {
        var labels = [UILabel]()
        let attributes: [NSAttributedString.Key: Any] = [
            .font : Design.dayFont,
            .kern : Design.dayLetterSpace
        ]
        WeekDay.allCases.forEach { weekday in
            let dayColor: UIColor
            let label = UILabel()
            if weekday == .sunday {
                dayColor = Design.sundayColor
            } else if weekday == .saturday {
                dayColor = Design.saturdayColor
            } else {
                dayColor = Design.dayColor
            }
            let attributedText = NSAttributedString(string: weekday.stringValue, attributes: attributes)
            label.textColor = dayColor
            label.attributedText = attributedText
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            labels.append(label)
        }
        
        return labels
    }()
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initView() {
        addSubview(weekDayView)
        dayLabels.forEach { weekDayView.addArrangedSubview($0) }
        setConstraint()
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            weekDayView.topAnchor.constraint(equalTo: topAnchor),
            weekDayView.leftAnchor.constraint(equalTo: leftAnchor),
            weekDayView.rightAnchor.constraint(equalTo: rightAnchor),
            weekDayView.heightAnchor.constraint(equalToConstant: Design.weekDayHeight)
        ])
    }
}
