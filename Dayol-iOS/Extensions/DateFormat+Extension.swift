//
//  DateFormat+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/01.
//

import Foundation

enum DateType {
    case yearMonthDay
    case yearMonth
    case year
    case month
    case day

    var formatter: DateFormatter {
        let dateForamtter = DateFormatter()
        switch self {
        case .yearMonthDay:
            dateForamtter.dateFormat = "yyyy.M d"
        case .yearMonth:
            dateForamtter.dateFormat = "yyyy.M"
        case .year:
            dateForamtter.dateFormat = "yyyy"
        case .month:
            dateForamtter.dateFormat = "M"
        case .day:
            dateForamtter.dateFormat = "d"
        }
        return dateForamtter
    }

    func date(year: Int, month: Int, day: Int) -> Date? {
        let dateString = "\(year).\(month) \(day)"
        return self.formatter.date(from: dateString)
    }
}
