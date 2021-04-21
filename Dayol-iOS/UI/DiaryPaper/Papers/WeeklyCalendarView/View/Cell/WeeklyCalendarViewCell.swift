//
//  WeeklyCalendarViewCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/01.
//

import UIKit

private enum Design {
    static let weekdayLetterSpace: CGFloat = -0.42
    static let dayLetterSpace: CGFloat = -0.24
    
    static let weeklyLabelLetterSpace: CGFloat = -0.24
    static let weeklyLabelColor: UIColor = UIColor(decimalRed: 0, green: 0, blue: 0, alpha: 0.2)
    static let weeklyLabelFont = UIFont.systemFont(ofSize: 13, weight: .bold)
    
    static let saturdayColor: UIColor = UIColor(decimalRed: 43, green: 81, blue: 206)
    static let sundayColor: UIColor = UIColor.dayolRed
    
    static let weekdayFont = UIFont.systemFont(ofSize: 11, weight: .bold)
    static let dayFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    static let dayLabelTop: CGFloat = 8
    static let dayLabelLeft: CGFloat = isPadDevice ? 10 : 8
    
    static let weeklyLabelTop: CGFloat = 8
    static let weeklyLabelLeft: CGFloat = isPadDevice ? 10 : 8
    
    static let weekdayLabelLeft: CGFloat = 8
    // TODO: Event Design
    
    static let separatorLineColor: UIColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorLineWidth: CGFloat = 1
}

class WeeklyCalendarViewCell: UICollectionViewCell {
    private enum LabelType {
        case day
        case weekly
        case weekday
    }
    
    static let identifier: String = "\(WeeklyCalendarViewCell.self)"
    
    private let rightSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let topSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let weeklyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let weekdayLabel: UILabel = {
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
        setFirstCell(true)
    }
    
    private func initView() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weeklyLabel)
        contentView.addSubview(weekdayLabel)
        contentView.addSubview(rightSeparatorLine)
        contentView.addSubview(topSeparatorLine)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.dayLabelTop),
            dayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Design.dayLabelLeft),
            
            weeklyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.weeklyLabelTop),
            weeklyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Design.weeklyLabelLeft),
            
            weekdayLabel.leftAnchor.constraint(equalTo: dayLabel.rightAnchor, constant: Design.weekdayLabelLeft),
            weekdayLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            
            rightSeparatorLine.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            rightSeparatorLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightSeparatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightSeparatorLine.widthAnchor.constraint(equalToConstant: Design.separatorLineWidth),
            
            topSeparatorLine.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topSeparatorLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeparatorLine.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            topSeparatorLine.heightAnchor.constraint(equalToConstant: Design.separatorLineWidth)
        ])
    }

    func configure(model: WeeklyCalendarDataModel) {
        dayLabel.attributedText = attributedString(type: .day, model: model)
        weeklyLabel.attributedText = attributedString(type: .weekly, model: model)
        weekdayLabel.attributedText = attributedString(type: .weekday, model: model)
        
        setFirstCell(false)
    }
    
    func setFirstCell(_ isFirst: Bool) {
        dayLabel.isHidden = isFirst
        weekdayLabel.isHidden = isFirst
        weeklyLabel.isHidden = !isFirst
    }
    
    private func attributedString(type: LabelType, model: WeeklyCalendarDataModel) -> NSAttributedString {
        switch type {
        case .day:
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: Design.dayLetterSpace,
                .font: Design.dayFont
            ]
            
            return NSAttributedString(string: String(model.day), attributes: attributes)
        case .weekday:
            var fontColor = UIColor.gray900
            if model.weekDay == .sunday {
                fontColor = Design.sundayColor
            } else if model.weekDay == .saturday {
                fontColor = Design.saturdayColor
            }
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: Design.weekdayLetterSpace,
                .font: Design.weekdayFont,
                .foregroundColor: fontColor
            ]
            
            return NSAttributedString(string: model.weekDay.stringValue, attributes: attributes)
        case .weekly:
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: Design.weeklyLabelLetterSpace,
                .font: Design.dayFont,
                .foregroundColor: Design.weeklyLabelColor
            ]
            
            return NSAttributedString(string: "WEEKLY", attributes: attributes)
        }
    }
}
