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
    
    init(dayNumber: Int, isCurrentMonth: Bool, isToday: Bool = false) {
        self.dayNumber = dayNumber
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
    }
}

class MonthlyCalendarViewModel: PaperViewModel {
    private var firstWeekDayOfMonth: WeekDay = .sunday
    private let model: MonthlyCalendarModel
    
    
    init(date: Date) {
        model = MonthlyCalendarModel(date: date)
        super.init(drawModel: DrawModel())
    }
    
    private var days: [MonthlyCalendarDayModel] {
        var daysResult = [MonthlyCalendarDayModel]()
        let maxCount = 42
        let year = model.year
        let month = model.monthIndex
        let prevMonthRemainDaysCount = model.prevMonthRemainDayCount
        let prevMonthMaxDay = model.numOfDaysInPrev
        let currentMonthCount = model.numOfDays
        
        for index in 0..<maxCount {
            let isPrevMonth = index < prevMonthRemainDaysCount
            let isCurrentMonth = index >= prevMonthRemainDaysCount && index < prevMonthRemainDaysCount + currentMonthCount
            
            if isPrevMonth {
                let day = prevMonthMaxDay - prevMonthRemainDaysCount + index + 1
                let dayModel = MonthlyCalendarDayModel(dayNumber: day, isCurrentMonth: false)
                daysResult.append(dayModel)
            } else if isCurrentMonth {
                let day = index - prevMonthRemainDaysCount + 1
                let isToday = String(day) == Date.now.dayString() && String(month+1) == Date.now.monthString() && String(year) == Date.now.yearString()
                let dayModel = MonthlyCalendarDayModel(dayNumber: day, isCurrentMonth: true, isToday: isToday)
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
    func dateModel() -> Observable<MonthlyCalendarDataModel> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            let days = self.days
            let month = Month(rawValue: self.model.monthIndex) ?? .january
            let dateModel = MonthlyCalendarDataModel(
                year: self.model.year,
                month: month,
                days: days
            )
            
            observer.onNext(dateModel)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
