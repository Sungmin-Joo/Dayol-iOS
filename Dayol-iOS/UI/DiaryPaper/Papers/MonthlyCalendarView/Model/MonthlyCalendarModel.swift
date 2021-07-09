//
//  MonthlyCalendarModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import Foundation

final class MonthlyCalendarModel {
    private let date: Date
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]

    init(date: Date) {
        self.date = date
    }
}

extension MonthlyCalendarModel {
    var year: Int {
        Calendar.current.component(.year, from: date)
    }

    var today: Int {
        Calendar.current.component(.day, from: date)
    }

    var month: Int {
        Calendar.current.component(.month, from: date)
    }

    var firstWeekday: WeekDay {
        let day = ("\(year).\(month) 01".date(with: .yearMonthDay)?.firstDayOfTheMonth.weekday)!
        return WeekDay(rawValue: day) ?? .sunday
    }

    var monthIndex: Int {
        month - 1
    }

    var numOfDays: Int {
        if month == 2 && year % 4 == 0 {
            return numOfDaysInMonth[monthIndex] + 1
        }
        return numOfDaysInMonth[monthIndex]
    }

    var numOfDaysInPrev: Int {
        let prevMonth = month - 1 > 0 ? month - 1 : 12
        if prevMonth == 2 && year % 4 == 0 {
            return numOfDaysInMonth[prevMonth - 1] + 1
        }
        return numOfDaysInMonth[prevMonth - 1]
    }

    var prevMonthRemainDayCount: Int {
        let weekdayRawValue = firstWeekday.rawValue - WeekDay.sunday.rawValue - 1

        if weekdayRawValue < 0 {
            return weekdayRawValue + 7
        }
        return weekdayRawValue
    }

    var weekSchedules: [ScheduleModel] {
        return [ScheduleModel]()
    }
}
