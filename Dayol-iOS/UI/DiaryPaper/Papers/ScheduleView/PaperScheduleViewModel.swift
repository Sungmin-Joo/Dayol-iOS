//
//  PaperScheduleViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/08.
//

import Foundation
import RxSwift

enum PaperSchdeuleType {
    case empty(day: Int)
    case schedule(day: Int, name: String, colorHex: String)
}

final class PaperScheduleViewModel {
    private var schedules: [PaperSchdeuleType] = []
}
