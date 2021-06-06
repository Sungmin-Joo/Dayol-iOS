//
//  DateFormat+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/01.
//

import Foundation

extension DateFormatter {
    static func createDate(year: Int, month: Int = 1, day: Int = 1) -> Date? {
        let string = "\(year).\(month) \(day)"
        let date = Self.yearMonthDay.date(from: string)

        return date
    }

    static var yearMonthDay: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M d"

        return dateFormatter
    }

    static var yearMonth: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M"

        return dateFormatter
    }

    static var year: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return dateFormatter
    }

    static var month: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"

        return dateFormatter
    }

    static var day: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        return dateFormatter
    }
}
