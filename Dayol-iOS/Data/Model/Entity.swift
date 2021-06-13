//
//  Diary.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/12.
//

import Foundation
import CoreData

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

extension Diary {
    func makeMo() -> DiaryMO? {
        return nil
    }
}

struct Paper: Codable {
    enum PaperOrientation: String {
        case portrait = "PORTRAIT"
        case landscape = "LANDSCAPE"
    }

    let id: String // P1, P2
    let diaryId: String
    let title: String
    let pageCount: Int32
    let orientation: String
    let width: Float
    let height: Float

    var thumbnail: Data
    var drawCanvas: Data
    var contents: [DecorationItem]
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
