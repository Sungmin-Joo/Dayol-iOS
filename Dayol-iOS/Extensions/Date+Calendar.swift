//
//  Date+Calendar.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/19.
//

import Foundation

extension Date {
    static let now = Date()

    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()

    func year(add value: Int = 0) -> String {
        let year = Date.calendar.date(byAdding: .year, value: value, to: self) ?? Date()

        return DateType.year.formatter.string(from: year)
    }

    func month(add value: Int = 0) -> String {
        let month = Date.calendar.date(byAdding: .month, value: value, to: self) ?? Date()

        return DateType.month.formatter.string(from: month)
    }

    func day(add value: Int = 0) -> String {
        let month = Date.calendar.date(byAdding: .day, value: value, to: self) ?? Date()

        return DateType.day.formatter.string(from: month)
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
