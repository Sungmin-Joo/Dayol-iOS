//
//  Date+Calendar.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/19.
//

import Foundation

extension Date {
    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()
    
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
