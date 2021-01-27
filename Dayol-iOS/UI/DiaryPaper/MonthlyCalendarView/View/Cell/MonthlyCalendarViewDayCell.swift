//
//  MonthlyCalendarViewDayCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/26.
//

import UIKit

private enum Design {
    static let daySize: CGSize = CGSize(width: 16, height: 16)
    static let dayFont: UIFont = UIFont.systemFont(ofSize: 11, weight: .regular)
    static let dayLetterSpace: CGFloat = -0.2
    static let dayTextColorForCurrentMonth: UIColor = .black
    static let dayTextColorForOtherMonth = UIColor.black.withAlphaComponent(0.2)
    static let todayBackground: UIColor = UIColor(decimalRed: 226, green: 226, blue: 226)
    static let todayRadius: CGFloat = 8
    
    static let dayTop: CGFloat = 2
    static let dayLabelLeft: CGFloat = 2
    static let dayLabelRight: CGFloat = 2
}

class MonthlyCalendarViewDayCell: UICollectionViewCell {
    static let identifier = "\(MonthlyCalendarViewDayCell.self)"

    
    private let dayBackgroundView: UIView = {
        let view =  UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Design.todayRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.backgroundColor = .clear
    }
    
    private func initView() {
        contentView.addSubview(dayBackgroundView)
        dayBackgroundView.addSubview(dayLabel)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            dayBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.dayTop),
            dayBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: dayBackgroundView.topAnchor),
            dayLabel.leftAnchor.constraint(equalTo: dayBackgroundView.leftAnchor, constant: Design.dayLabelLeft),
            dayLabel.rightAnchor.constraint(equalTo: dayBackgroundView.rightAnchor, constant: -Design.dayLabelRight),
            dayLabel.bottomAnchor.constraint(equalTo: dayBackgroundView.bottomAnchor),
            dayLabel.heightAnchor.constraint(equalToConstant: Design.daySize.height)
        ])
    }
    
    private func dayAttributedString(_ day: Int, isCurrentMonth: Bool) -> NSAttributedString {
        let dayString = String(day)
        let textColor = isCurrentMonth ? Design.dayTextColorForCurrentMonth : Design.dayTextColorForOtherMonth
        let attributes: [NSAttributedString.Key : Any] = [
            .font : Design.dayFont,
            .kern : Design.dayLetterSpace,
            .foregroundColor : textColor,
        ]
        
        return NSAttributedString(string: dayString, attributes: attributes)
    }
    
    func configure(model: MonthlyCalendarDayModel) {
        dayLabel.attributedText = dayAttributedString(model.dayNumber, isCurrentMonth: model.isCurrentMonth)
        dayBackgroundView.backgroundColor = model.isToday ? Design.todayBackground : .clear
    }
}
