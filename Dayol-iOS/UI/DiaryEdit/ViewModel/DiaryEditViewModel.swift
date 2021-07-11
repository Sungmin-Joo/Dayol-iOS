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

    var diaryID: String {
        let diaryPrefix = "D"
        if let diaryId = currentDiaryId {
            return diaryId
        }
        return diaryPrefix + String(Date().timeIntervalSince1970)
    }

    var diaryIndex: Int32 {
        let diaryList = DiaryManager.shared.diaryList

        if let index = diaryList.firstIndex(where: { $0.id == diaryID }) {
            return Int32(index)
        }

        return Int32(diaryList.count)
    }

    func createDiaryInfo(
        isLock: Bool,
        title: String,
        colorHex: String,
        drawCanvas: Data,
        hasLogo: Bool,
        thumbnail: Data,
        contents: [DecorationItem]
    ) {
        let diaryModel = Diary(
            id: diaryID,
            isLock: isLock,
            index: diaryIndex,
            title: title,
            colorHex: colorHex,
            hasLogo: hasLogo,
            thumbnail: thumbnail,
            drawCanvas: drawCanvas,
            contents: contents
        )

        if currentDiaryId == nil {
            DiaryManager.shared.createDiary(diaryModel)
        } else {
            DiaryManager.shared.updateDiary(diaryModel)
            DiaryManager.shared.fetchDiaryList()
        }

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
