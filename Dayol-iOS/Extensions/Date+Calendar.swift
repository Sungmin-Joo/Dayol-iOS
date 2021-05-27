//
//  Date+Calendar.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/19.
//

import Foundation

extension DateFormatter {
    static var year: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return dateFormatter
    }
}

extension Date {
    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()

    static func year(from date: Date, add value: Int) -> String {
        let year = Date.calendar.date(byAdding: .year, value: value, to: date) ?? Date()

        return DateFormatter.year.string(from: year)
    }

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    var isWeekend: Bool {
        return Date.calendar.isDateInWeekend(self)
    }
}
