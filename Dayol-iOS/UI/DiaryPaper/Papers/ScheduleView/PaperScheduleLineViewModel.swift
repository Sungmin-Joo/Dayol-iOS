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
        let endDateOfWeek = firstDateOfWeek.day(add: 6)
        var baseMomentDate = firstDateOfWeek
        var processedDays = 0
        var isFirstDraw = true

        scheduleModels.forEach { model in
            let startDateDayDiff = baseMomentDate.dayDiff(with: model.start) ?? 0
            if isFirstDraw == false, startDateDayDiff < 0 {
                return
            } else {
                if startDateDayDiff > 0 {
                    schedules.append(.empty(day: startDateDayDiff))
                    baseMomentDate = model.start
                    processedDays += startDateDayDiff
                }

                if processedDays < 7 {
                    let endScheduleDay = min(endDateOfWeek, model.end)
                    let endDateDayDiff = baseMomentDate.dayDiff(with: endScheduleDay) ?? 0
                    if endDateDayDiff >= 0 {
                        schedules.append(.schedule(day: endDateDayDiff + 1, name: model.name, colorHex: model.colorHex))
                        baseMomentDate = model.end.day(add: 1)
                        processedDays += endDateDayDiff + 1
                        isFirstDraw = false
                        PaperScheduleStoreManager.shared.deleteSchedule(scheduleId: model.id)
                    }
                }
            }
        }

        if processedDays < Constant.maxDaysOfWeek {
            schedules.append(.empty(day: Constant.maxDaysOfWeek - processedDays))
        }
    }
}
