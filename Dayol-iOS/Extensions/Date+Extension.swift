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

    func yearString(add value: Int = 0) -> String {
        return year(add: value).string(with: .year)
    }

    func monthString(add value: Int = 0) -> String {
        return month(add: value).string(with: .month)
    }

    func dayString(add value: Int = 0) -> String {
        return day(add: value).string(with: .day)
    }

    func hour(add value: Int = 0) -> Date {
        let hour = Date.calendar.date(byAdding: .hour, value: value, to: self) ?? Date()

        return hour
    }

    func day(add value: Int = 0) -> Date {
        return Date.calendar.date(byAdding: .day, value: value, to: self) ?? Date()
    }

    func month(add value: Int = 0) -> Date {
        return Date.calendar.date(byAdding: .month, value: value, to: self) ?? Date()
    }

    func year(add value: Int = 0) -> Date {
        return Date.calendar.date(byAdding: .year, value: value, to: self) ?? Date()
    }

    func dayDiff(with date: Date) -> Int? {
        return Date.calendar.dateComponents([.day], from: self, to: date).day
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
