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

enum PaperStyle: String, CaseIterable {
    case horizontal
    case vertical
}

enum PaperType: Equatable {

    case monthly(date: Date)
    case weekly(date: Date)
    case daily(date: Date)
    case cornell
    case muji
    case grid
    case four
    case tracker

    static var allCases: [PaperType] {
        return [.monthly(date: Date()),
                .weekly(date: Date()),
                .daily(date: Date()),
                .cornell,
                .muji,
                .grid,
                .four,
                .tracker]
    }

    var title: String {
        switch self {
        case .monthly(let date): return DateFormatter.yearMonth.string(from: date)
        case .weekly(let date):
            let startDateString = DateFormatter.yearMonthDay.string(from: date)
            let endDate = Date.calendar.date(byAdding: .day, value: 7, to: date) ?? Date()
            let endDateString = DateFormatter.yearMonthDay.string(from: endDate)
            return "\(startDateString) ~ \(endDateString)"
        case .daily(let date): return DateFormatter.yearMonthDay.string(from: date)
        case .cornell: return "memo_list_kornell".localized
        case .muji: return "memo_list_muji".localized
        case .grid: return "memo_list_grid".localized
        case .four: return "memo_list_4cell".localized
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
        case .four: return FourPaper.self
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
        case .four: return FourPaper.className
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
        case .four: return nil
        case .tracker: return nil
        }
    }

    static func ==(lhs: PaperType, rhs: PaperType) -> Bool {
        switch (lhs, rhs) {
        case (.monthly(let lDate), .monthly(date: let rDate)):
            let isSameYear = Date.year(from: lDate) == Date.year(from: rDate)
            let isSameMonth = Date.month(from: lDate) == Date.month(from: rDate)
            return isSameYear && isSameMonth
        case (.daily(let lDate), .daily(date: let rDate)):
            let isSameYear = Date.year(from: lDate) == Date.year(from: rDate)
            let isSameMonth = Date.month(from: lDate) == Date.month(from: rDate)
            let isSameDay = Date.day(from: lDate) == Date.day(from: rDate)
            return isSameYear && isSameMonth && isSameDay
        default:
            return false
        }
    }
}

extension PaperStyle {
    var size: CGSize {
        switch self {
        case .vertical: return CGSize(width: 614.0, height: 917.0)
        case .horizontal: return CGSize(width: 1024.0, height: 662.0)
        }
    }

    var maximumZoomIn: CGFloat {
        return 3.0
    }

    func contentStackViewInset(scrollViewSize: CGSize) -> UIEdgeInsets {
        let width = scrollViewSize.width
        let gap = (width - size.width) / 2
        return UIEdgeInsets(top: 0, left: gap, bottom: 20, right: gap)
    }

    func minimumZoomOut(scrollViewSize: CGSize) -> CGFloat {
        switch self {
        case .horizontal:
            return scrollViewSize.width / size.width
        case .vertical:
            return scrollViewSize.height / size.height
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
