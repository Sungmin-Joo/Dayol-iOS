//
//  DateFormat+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/01.
//

import Foundation

enum DateType {
    case schedule
    case yearMonthDay
    case yearMonth
    case year
    case month
    case day
    case time

    var formatter: DateFormatter {
        let dateForamtter = DateFormatter()
        switch self {
        case .schedule:
            dateForamtter.dateFormat = "yyyy.M.dd(E)"
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
        case .time:
            dateForamtter.dateFormat = "a h:mm"
        }
        return dateForamtter
    }

    func date(year: Int, month: Int, day: Int) -> Date? {
        let dateString = "\(year).\(month) \(day)"
        return self.formatter.date(from: dateString)
    }

    func dateToString(_ date: Date) -> String {
        return self.formatter.string(from: date)
    }
}
