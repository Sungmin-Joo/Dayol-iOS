//
//  Diary.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/12.
//

import UIKit

struct Diary: Codable {
    let id: String // D1, D2
    // TODO: - 컴퓨티드 프로퍼티로 구현 - @박종상
//    let isLock: Bool
    let title: String
    let papers: [Paper]
    let colorHex: String

    var isLock: Bool = false
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

        init(value: PaperStyle) {
            switch value {
            case .horizontal:
                self = .landscape
            case .vertical:
                self = .portrait
            }
        }
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

        init(value: PaperType) {
            switch value {
            case .monthly(date: _):
                self = .monthly
            case .weekly(date: _):
                self = .weekly
            case .daily(date: _):
                self = .daily
            case .cornell:
                self = .cornell
            case .muji:
                self = .muji
            case .grid:
                self = .grid
            case .four:
                self = .four
            case .tracker:
                self = .tracker
            }
        }
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

    init(id: String,
         diaryId: String,
         title: String,
         pageCount: Int,
         orientation: PaperOrientation,
         type: PaperRawType,
         width: CGFloat,
         height: CGFloat,
         thumbnail: UIImage?,
         drawCanvas: Data,
         contents: [DecorationItem],
         date: Date?) {
        self.id = id
        self.diaryId = diaryId
        self.title = title
        self.pageCount = Int32(pageCount)
        self.orientation = orientation.rawValue
        self.type = type.rawValue
        self.width = Float(width)
        self.height = Float(height)
        self.thumbnail = thumbnail?.pngData()
        self.drawCanvas = drawCanvas
        self.contents = contents
        self.date = date
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
