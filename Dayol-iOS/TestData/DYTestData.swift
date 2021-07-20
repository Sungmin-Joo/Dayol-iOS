//
//  DiaryListTestData.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/08.
//

import UIKit
import RxSwift

// MARK: - 다이어리 한 개당 내부에 표현될 데이터를 테스트하기위해 작성한 코드입니다.

struct ScheduleModel {
    let id: String
    let diaryId: Int
    let start: Date
    let end: Date
    let content: String
    let colorHex: String
    let linkPaperId: Int
    let appliedType: PaperType
}

class DYTestData {
    static let shared = DYTestData()
    static let testDrawModel = DrawModel(lines: [], stickers: [], labels: [])

    var currentPaperId: String {
        return "Paper_\(paperList.count)"
    }

    lazy var deletedPageListSubject = BehaviorSubject<[DeletedPageCellModel]>(value: deletedPageList)
    lazy var paperListSubject = BehaviorSubject<[Paper]>(value: paperList)
    lazy var needsPaperUpdate = PublishSubject<Paper>()
    
    var deletedPageList: [DeletedPageCellModel] = [
        // TODO: - DeletedPageCellModel가 아닌 delete 모델 구현 후 연동
    ]

    var paperList: [Paper] = [

    ]

    var scheduleModels: [PaperScheduler] = [
        PaperScheduler(id: "S0", diaryId: "D0", start: Date.now.day(), end: Date.now.day(add: 7), name: "스케줄 1", colorHex: UIColor.dayolRed.hexString, showsWeeklyPaper: true, showsMonthlyPaper: true),
        PaperScheduler(id: "S1", diaryId: "D0", start: Date.now.day(add: 1), end: Date.now.day(add: 9), name: "스케줄 2", colorHex: UIColor.dayolBrown.hexString, showsWeeklyPaper: true, showsMonthlyPaper: true),
        PaperScheduler(id: "S2", diaryId: "D0", start: Date.now.day(add: 2), end: Date.now.day(add: 6), name: "스케줄 3", colorHex: UIColor.systemBlue.hexString, showsWeeklyPaper: true, showsMonthlyPaper: true)
    ]
    
    var stickerList: [UIImage?] = [
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
    ]

// MARK: -Deleted Paper

    func addDeletedPage(_ page: DeletedPageCellModel) {
        deletedPageList.append(page)
        paperListSubject.onNext(paperList)
    }

    func deleteDeletedPage(_ page: DeletedPageCellModel) {
        // TODO: - DeletedPageCellModel가 아닌 delete 모델 구현 후 연동
        guard let index = deletedPageList.firstIndex(where: { $0.id == page.id }) else { return }
        paperList.remove(at: index)
        paperListSubject.onNext(paperList)
    }

    func deleteAllPage() {
        paperList = []
        paperListSubject.onNext(paperList)
    }
    
    func deleteAllDeletedPage() {
        deletedPageList = []
        deletedPageListSubject.onNext(deletedPageList)
    }

// MARK: -Paper
    
    func addPaper(_ model: Paper) {
        paperList.append(model)
        paperListSubject.onNext(paperList)
    }

    func deletePaper(_ model: Paper) {
        guard let index = paperList.firstIndex(where: { $0.id == model.id }) else { return }
        paperList.remove(at: index)

        paperListSubject.onNext(paperList)
    }

    func deletePaper(with paperId: String) {
        guard let index = paperList.firstIndex(where: { $0.id == paperId }) else { return }
        paperList.remove(at: index)

        paperListSubject.onNext(paperList)
    }

    func reorderPaper(from sourceIndex: Int, to destinationIndex: Int) {
        guard let source = paperList[safe: sourceIndex] else { return }

        if sourceIndex > destinationIndex {
            paperList.remove(at: sourceIndex)
            paperList.insert(source, at: destinationIndex)
        } else {
            paperList.insert(source, at: destinationIndex + 1)
            paperList.remove(at: sourceIndex)
        }
        paperListSubject.onNext(paperList)
    }

    func addPaperThumbnail(id: String, thumbnail: UIImage?) {
        guard let index = paperList.firstIndex(where: { $0.id == id }) else { return }
        guard let thumbnailData = thumbnail?.pngData() else { return }
        paperList[index].thumbnail = thumbnailData
    }

    func updateFavorite(paperId: String, isFavorite: Bool) {
        guard let index = paperList.firstIndex(where: { $0.id == paperId }) else { return }
        paperList[index].isFavorite = isFavorite

        needsPaperUpdate.onNext(paperList[index])
    }

    func updatePaperContents(id: String, items: [DecorationItem], drawing: Data? = nil) {
        guard let index = paperList.firstIndex(where: { $0.id == id }) else { return }
        paperList[index].contents = items
        paperList[index].drawCanvas = drawing ?? Data()
        needsPaperUpdate.onNext(paperList[index])
    }

    func addSchedule(_ model: PaperScheduler) {
        scheduleModels.append(model)
    }

    func findSchedule(diaryId: String, include date: Date) -> [PaperScheduler] {
        return scheduleModels.filter { model -> Bool in
            return model.diaryId == diaryId && model.start <= date && model.end >= date
        }
    }

    func removeSchedule(id: String) {
        guard let toRemoveIndex = scheduleModels.firstIndex(where: { $0.id == id }) else { return }
        scheduleModels.remove(at: toRemoveIndex)
    }
}

// MARK: - Diary Decorate Item Id

extension DYTestData {
    static var lastTextFieldID: Int = 0

    var textFieldIdToCreate: String {
        return String(Self.lastTextFieldID)
    }

    func increaseTextFieldID() {
        Self.lastTextFieldID += 1
    }
}
