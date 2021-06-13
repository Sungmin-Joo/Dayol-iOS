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
        return DYTestData.shared.currentDiaryId
    }

    func createDiaryInfo(model: Diary) {
        DYTestData.shared.addDiary(model)
    }

    func setDiaryInfo(model: Diary) {
        diarySubject.onNext(model)
        currentDiaryId = model.id
    }
}
