//
//  PaperScheduleLineViewModel.swift
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

private enum Constant {
    static let maxDaysOfWeek = 7
}

final class PaperScheduleLineViewModel {
    private(set) var schedules: [PaperSchdeuleType] = []
    private let scheduleModels: [PaperScheduler]
    private let firstDateOfWeek: Date

    init(scheduleModels: [PaperScheduler], firstDateOfWeek: Date) {
        self.firstDateOfWeek = firstDateOfWeek
        self.scheduleModels = scheduleModels

        makeScheduleTypes()
    }

    private func makeScheduleTypes() {
        var baseMomentDate = firstDateOfWeek
        var processedDays = 0

        scheduleModels.forEach { model in
            if model.start > baseMomentDate {
                let dayDiff = (baseMomentDate.dayDiff(with: model.start) ?? 0) + 1
                schedules.append(.empty(day: dayDiff))
                baseMomentDate = model.start.day()
                processedDays += dayDiff
            }

            let dayDiff = (baseMomentDate.dayDiff(with: model.end) ?? 0) + 1
            schedules.append(.schedule(day: dayDiff, name: model.name, colorHex: model.colorHex))
            baseMomentDate = model.end.day()
            processedDays += dayDiff
        }

        if processedDays < Constant.maxDaysOfWeek {
            schedules.append(.empty(day: Constant.maxDaysOfWeek - processedDays))
        }
    }
}
