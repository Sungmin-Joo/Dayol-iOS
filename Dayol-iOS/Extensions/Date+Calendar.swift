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

    static func year(from date: Date, add value: Int = 0) -> String {
        let year = Date.calendar.date(byAdding: .year, value: value, to: date) ?? Date()

        return DateFormatter.year.string(from: year)
    }

    static func month(from date: Date, add value: Int = 0) -> String {
        let month = Date.calendar.date(byAdding: .month, value: value, to: date) ?? Date()

        return DateFormatter.month.string(from: month)
    }

    static func day(from date: Date, add value: Int = 0) -> String {
        let month = Date.calendar.date(byAdding: .day, value: value, to: date) ?? Date()

        return DateFormatter.day.string(from: month)
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
