//
//  PaperModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit

enum CommonPaperDesign {
    static let defaultBGColor = UIColor.white
    static let borderColor = UIColor(decimalRed: 233, green: 233, blue: 233)
}

enum PaperType: Equatable {
    case monthly(date: Date)
    case weekly(date: Date)
    case daily(date: Date)
    case cornell
    case muji
    case grid
    case quartet
    case tracker

    init?(rawValue: String, date: Date? = nil) {
        if rawValue == Paper.PaperRawType.monthly.rawValue {
            guard let date = date else { return nil }
            self = .monthly(date: date)
        } else if rawValue == Paper.PaperRawType.weekly.rawValue {
            guard let date = date else { return nil }
            self = .weekly(date: date)
        } else if rawValue == Paper.PaperRawType.daily.rawValue {
            guard let date = date else { return nil }
            self = .daily(date: date)
        } else if rawValue == Paper.PaperRawType.cornell.rawValue {
            self = .cornell
        } else if rawValue == Paper.PaperRawType.muji.rawValue {
            self = .muji
        } else if rawValue == Paper.PaperRawType.grid.rawValue {
            self = .grid
        } else if rawValue == Paper.PaperRawType.quartet.rawValue {
            self = .quartet
        } else {
            self = .tracker
        }
    }

    static var allCases: [PaperType] {
        return [.monthly(date: Date()),
                .weekly(date: Date()),
                .daily(date: Date()),
                .cornell,
                .muji,
                .grid,
                .quartet,
                .tracker]
    }

    var title: String {
        switch self {
        case .monthly(let date):
            return DateType.yearMonth.formatter.string(from: date)
        case .weekly(let date):
            let startDateString = DateType.yearMonthDay.formatter.string(from: date)
            let endDate = Date.calendar.date(byAdding: .day, value: 7, to: date) ?? Date()
            let endDateString = DateType.yearMonthDay.formatter.string(from: endDate)
            return "\(startDateString) ~ \(endDateString)"
        case .daily(let date): return DateType.yearMonthDay.formatter.string(from: date)
        case .cornell: return "memo_list_kornell".localized
        case .muji: return "memo_list_muji".localized
        case .grid: return "memo_list_grid".localized
        case .quartet: return "memo_list_4cell".localized
        case .tracker: return "memo_list_tracker".localized
        }
    }

    var typeName: String {
        switch self {
        case .monthly(let _): return "memo_list_monthly".localized
        case .weekly(let _): return "memo_list_weekly".localized
        case .daily(let _): return "memo_list_daily".localized
        case .cornell: return "memo_list_kornell".localized
        case .muji: return "memo_list_muji".localized
        case .grid: return "memo_list_grid".localized
        case .quartet: return "memo_list_4cell".localized
        case .tracker: return "memo_list_tracker".localized
        }
    }

    var cellType: UITableViewCell.Type {
        switch self {
        case .monthly: return MonthlyCalendarView.self
        case .weekly: return WeeklyCalendarView.self
        case .daily: return DailyPaper.self
        case .cornell: return CornellPaper.self
        case .muji: return MujiPaper.self
        case .grid: return GridPaper.self
        case .quartet: return QuartetPaper.self
        case .tracker: return BasePaper.self
        }
    }

    var identifier: String {
        switch self {
        case .monthly: return MonthlyCalendarView.className
        case .weekly: return WeeklyCalendarView.className
        case .daily(_): return DailyPaper.className
        case .cornell: return CornellPaper.className
        case .muji: return MujiPaper.className
        case .grid: return GridPaper.className
        case .quartet: return QuartetPaper.className
        case .tracker: return BasePaper.className
        }
    }

    var thumbnail: UIImage? {
        switch self {
        case .monthly: return UIImage(named: "PaperSelectThumbMonthly")
        case .weekly: return nil
        case .daily(_): return nil
        case .cornell: return nil
        case .muji: return nil
        case .grid: return nil
        case .quartet: return nil
        case .tracker: return nil
        }
    }

    var date: Date? {
        switch self {
        case .monthly(let date): return date
        case .weekly(let date): return date
        case .daily(let date): return date
        default: return nil
        }
    }

    static func ==(lhs: PaperType, rhs: PaperType) -> Bool {
        switch (lhs, rhs) {
        case (.monthly(let lDate), .monthly(date: let rDate)):
            let isSameYear = lDate.year() == rDate.year()
            let isSameMonth = lDate.month() == rDate.month()
            return isSameYear && isSameMonth
        case (.daily(let lDate), .daily(date: let rDate)):
            let isSameYear = lDate.year() == rDate.year()
            let isSameMonth = lDate.month() == rDate.month()
            let isSameDay = lDate.day() == rDate.day()
            return isSameYear && isSameMonth && isSameDay
        default:
            return false
        }
    }
}

enum PaperOrientationConstant {
    static let maximumZoomIn: CGFloat = 3.0

    static func size(orentantion: Paper.PaperOrientation) -> CGSize {
        switch orentantion {
        case .portrait: return CGSize(width: 614.0, height: 917.0)
        case .landscape: return CGSize(width: 1024.0, height: 662.0)
        }
    }

    static func contentStackViewInset(orientation: Paper.PaperOrientation, scrollViewSize: CGSize) -> UIEdgeInsets {
        let scrollWidth = scrollViewSize.width
        let paperWidth = size(orentantion: orientation).width
        let gap = (scrollWidth - paperWidth) / 2
        return UIEdgeInsets(top: 0, left: gap, bottom: 20, right: gap)
    }

    static func minimumZoomOut(orientation: Paper.PaperOrientation, scrollViewSize: CGSize) -> CGFloat {
        let paperSize = size(orentantion: orientation)
        switch orientation {
        case .landscape:
            return scrollViewSize.width / paperSize.width
        case .portrait:
            return scrollViewSize.height / paperSize.height
        }
    }
}

struct Line {
    // drawing object에 대한 모델
}

struct Sticker {
    // sticker object에 대한 모델
}

struct Label {
    // label object에 대한 모델
}

struct DrawModel {
    var lines: [Line] = []
    var stickers: [Sticker] = []
    var labels: [Label]  = []
}
