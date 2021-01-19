//
//  MonthlyCalendarViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/19.
//

import Foundation
import RxSwift

enum WeekDay: Int {
    case sunday = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var stringValue: String {
        switch self {
        case .sunday:
            return "SUN"
        case .monday:
            return "MON"
        case .tuesday:
            return "TUE"
        case .wednesday:
            return "WED"
        case .thursday:
            return "THU"
        case .friday:
            return "FRI"
        case .saturday:
            return "SAT"
        }
    }
}

struct MonthlyCalendarDataModel {
    let year: Int
    let month: Int
    let days: [MonthlyCalendarDayModel]
}

struct MonthlyCalendarDayModel {
    let dayNumber: Int
    let isCurrentMonth: Bool
}

class MonthlyCalendarViewModel {
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var monthIndex: Int = 0
    private var year: Int = 0
    private var today = 0
    private var firstWeekDayOfMonth: WeekDay = .sunday
    
    init() {
        calcDate(date: Date())
    }
    
    private func calcDate(date: Date) {
        monthIndex = Calendar.current.component(.month, from: date)
        monthIndex -= 1
        
        year = Calendar.current.component(.year, from: date)
        today = Calendar.current.component(.day, from: date)

        firstWeekDayOfMonth = firstWeekDay(year: year, month: monthIndex)
        
        // 윤년
        if monthIndex == 1 && year % 4 == 0 {
            numOfDaysInMonth[monthIndex] = 29
        }
    }
    
    private func firstWeekDay(year: Int, month: Int) -> WeekDay {
        let day = ("\(year)-\(month+1)-01".date?.firstDayOfTheMonth.weekday)!
        return WeekDay(rawValue: day) ?? .sunday
    }
    
    private func days(year: Int, month: Int) -> [MonthlyCalendarDayModel] {
        var daysResult = [MonthlyCalendarDayModel]()
        let maxCount = 42
        let prevMonth: Int = (month - 1 < 0) ? 11 : month - 1
        let prevMonthRemainDaysCount = firstWeekDayOfMonth.rawValue - WeekDay.sunday.rawValue - 1
        let prevMonthMaxDay = numOfDaysInMonth[prevMonth]
        let currentMonthCount = numOfDaysInMonth[month]
        
        for index in 0..<maxCount {
            let isPrevMonth = index < prevMonthRemainDaysCount
            let isCurrentMonth = index >= prevMonthRemainDaysCount && index < prevMonthRemainDaysCount + currentMonthCount
            
            if isPrevMonth {
                let day = prevMonthMaxDay - prevMonthRemainDaysCount + index
                let dayModel = MonthlyCalendarDayModel(dayNumber: day, isCurrentMonth: false)
                daysResult.append(dayModel)
            } else if isCurrentMonth {
                let day = index - prevMonthRemainDaysCount + 1
                let dayModel = MonthlyCalendarDayModel(dayNumber: day, isCurrentMonth: true)
                daysResult.append(dayModel)
            } else {
                let day = index - prevMonthRemainDaysCount - currentMonthCount + 1
                let dayModel = MonthlyCalendarDayModel(dayNumber: day, isCurrentMonth: false)
                daysResult.append(dayModel)
            }
        }
        
        return daysResult
    }

}

extension MonthlyCalendarViewModel {
    func dateModel(date: Date) -> Observable<MonthlyCalendarDataModel> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            self.calcDate(date: date)
            let days = self.days(year: self.year, month: self.monthIndex)
            let dateModel = MonthlyCalendarDataModel(
                year: self.year,
                month: self.monthIndex,
                days: days
            )
            
            observer.onNext(dateModel)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
