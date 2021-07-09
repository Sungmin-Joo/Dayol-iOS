//
//  PaperScheldule.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/13.
//

import Foundation

struct PaperScheduler: Codable {
    let id: String // PS1, PS2
    let diaryId: String
    let start: Date
    let end: Date
    let name: String
    let colorHex: String
    let showsWeeklyPaper: Bool
    let showsMonthlyPaper: Bool
}
