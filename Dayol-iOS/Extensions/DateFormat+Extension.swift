//
//  DateFormat+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/01.
//

import Foundation

extension DateFormatter {
    static func yearMonthDate(from date: String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM"

        return dateFormatter.date(from: date)
    }

    static func yearMonthDayDate(from date: String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"

        return dateFormatter.date(from: date)
    }
}
