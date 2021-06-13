//
//  Diary.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/12.
//

import Foundation

struct Diary: Codable {
    let id: String // D1, D2
    let title: String
    let papers: [Paper]
    let colorHex: String

    var thumbnail: Data
    var drawCanvas: Data
    var contents: [DecorationItem]

    var paperCount: Int {
        papers.count
    }
}

struct Paper: Codable {
    enum PaperOrientation: String {
        case portrait = "PORTRAIT"
        case landscape = "LANDSCAPE"
    }

    enum PaperRawType: String {
        case monthly = "MONTHLY"
        case weekly = "WEEKLY"
        case daily = "DAILY"
        case cornell = "CORNELL"
        case muji = "MUJI"
        case grid = "GRID"
        case four = "FOUR"
        case tracker = "TRACKER"
    }

    let id: String // P1, P2
    let diaryId: String
    let title: String
    let pageCount: Int32
    let orientation: String
    let type: String
    let width: Float
    let height: Float

    var thumbnail: Data?
    var drawCanvas: Data
    var contents: [DecorationItem]

    var date: Date?
}

extension Paper {
    var paperStyle: PaperStyle {
        if orientation == PaperOrientation.portrait.rawValue {
            return .vertical
        } else {
            return .horizontal
        }
    }

    var paperType: PaperType {
        if type == PaperRawType.monthly.rawValue {
            guard let date = date else { return .muji }
            return .monthly(date: date)
        } else if type == PaperRawType.weekly.rawValue {
            guard let date = date else { return .muji }
            return .weekly(date: date)
        } else if type == PaperRawType.daily.rawValue {
            guard let date = date else { return .muji }
            return .daily(date: date)
        } else if type == PaperRawType.cornell.rawValue {
            return .cornell
        } else if type == PaperRawType.muji.rawValue {
            return .muji
        } else if type == PaperRawType.grid.rawValue {
            return .grid
        } else if type == PaperRawType.four.rawValue {
            return .four
        } else {
            return .tracker
        }
    }
}

struct PaperScheduler: Codable {
    let id: String // PS1, PS2
    let paperId: String
    let diaryId: String
    let start: Date
    let end: Date
    let name: String
    let colorHex: String
}
