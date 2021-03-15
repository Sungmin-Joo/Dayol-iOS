//
//  MonthlyCalendarViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/19.
//

import Foundation
import RxSwift

enum Month: Int, CaseIterable {
    case january = 0
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    var asString: String {
        switch self {
        case .january:
            return "January"
        case .february:
            return "February"
        case .march:
            return "March"
        case .april:
            return "April"
        case .may:
            return "May"
        case .june:
            return "June"
        case .july:
            return "July"
        case .august:
            return "August"
        case .september:
            return "September"
        case .october:
            return "October"
        case .november:
            return "November"
        case .december:
            return "December"
        }
    }
}

enum WeekDay: Int, CaseIterable {
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
    let month: Month
    let days: [MonthlyCalendarDayModel]
}

struct MonthlyCalendarDayModel {
    let dayNumber: Int
    let isCurrentMonth: Bool
    let isToday: Bool
    let events: [NSObject] // Mock Data
    
    init(dayNumber: Int, isCurrentMonth: Bool, isToday: Bool = false) {
        self.dayNumber = dayNumber
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
        self.events = [NSObject]() // Mock Data
    }
}

class MonthlyCalendarViewModel: PaperViewModel {
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var monthIndex: Int = 0
    private var year: Int = 0
    private var today = 0
    private var firstWeekDayOfMonth: WeekDay = .sunday
    
    init() {
        super.init(drawModel: DrawModel())
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
                let dayModel = MonthlyCalendarDayModel(dayNumber: day, isCurrentMonth: true, isToday: day == today)
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
            let month = Month(rawValue: self.monthIndex) ?? .january
            let dateModel = MonthlyCalendarDataModel(
                year: self.year,
                month: month,
                days: days
            )
            
            observer.onNext(dateModel)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
