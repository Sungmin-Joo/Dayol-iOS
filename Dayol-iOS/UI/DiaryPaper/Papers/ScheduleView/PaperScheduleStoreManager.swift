//
//  PaperScheduleStoreManager.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/10.
//

import Foundation

final class PaperScheduleStoreManager {
    static let shared = PaperScheduleStoreManager()

    private(set) var schedules: [PaperScheduler] = []

    func set(schedules: [PaperScheduler]) {
        self.schedules = schedules
    }

    func deleteSchedule(scheduleId: String) {
        guard let index = schedules.firstIndex(where: { $0.id == scheduleId }) else { return }
        schedules.remove(at: index)
    }
}
