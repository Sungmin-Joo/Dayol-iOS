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
    let firstDay: WeekDay
    let dayCount: Int
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
}

extension MonthlyCalendarViewModel {
    func dateModel(date: Date) -> Observable<MonthlyCalendarDataModel> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            self.calcDate(date: date)
            let dateModel = MonthlyCalendarDataModel(
                year: self.year,
                month: self.monthIndex,
                firstDay: self.firstWeekDayOfMonth,
                dayCount: self.numOfDaysInMonth[self.monthIndex]
            )
            observer.onNext(dateModel)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
