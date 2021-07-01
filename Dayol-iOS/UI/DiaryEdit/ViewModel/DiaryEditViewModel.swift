//
//  DiaryEditViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/08.
//

import Foundation
import RxSwift
import RxCocoa

class DiaryEditViewModel {
    let diaryColors: [PaletteColor] = PaletteColor.colorPreset.filter { $0 != .DYDark}
    let diaryInitalTitle: String = "새 다이어리"
    var diarySubject = ReplaySubject<Diary>.createUnbounded()
    var currentDiaryId: String?

    var diaryIdToCreate: String {
        if let diaryId = currentDiaryId {
            return diaryId
        }

        if let diaryList = try? DiaryManager.shared.diaryListSubject.value() {
            let count = diaryList.count
            return "D\(count)"
        }

        return "D0"
    }

    func createDiaryInfo(model: Diary) {
        if currentDiaryId == nil {
            DiaryManager.shared.createDiary(model)
        } else {
            DiaryManager.shared.updateDiary(model)
        }
    }

    func setDiaryInfo(model: Diary) {
        diarySubject.onNext(model)
        currentDiaryId = model.id
    }
}
