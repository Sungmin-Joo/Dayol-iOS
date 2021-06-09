//
//  DiaryListTestData.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/08.
//

import UIKit
import RxSwift

// MARK: - 다이어리 한 개당 내부에 표현될 데이터를 테스트하기위해 작성한 코드입니다.

// 다이어리 한 개의 내부 데이터에 대한 테스트 모델
struct PaperModel {
    let id: String
    let diaryId: String
    let paperStyle: PaperStyle
    let paperType: PaperType
    let paperTitle: String
    var numberOfPapers: Int
    var drawModelList: DrawModel
    var thumbnail: Data?

    init(id: String, diaryId: String, paperStyle: PaperStyle, paperType: PaperType, numberOfPapers: Int, drawModelList: DrawModel) {
        self.id = id
        self.diaryId = diaryId
        self.paperType = paperType
        self.paperStyle = paperStyle
        self.numberOfPapers = numberOfPapers
        self.drawModelList = drawModelList
        self.paperTitle = paperType.title
    }
}

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

    var currentDiaryId: String {
        return "Diary_\(diaryList.count)"
    }

    var currentPaperId: String {
        return "Paper_\(paperList.count)"
    }

    lazy var diaryListSubject = BehaviorSubject<[DiaryInfoModel]>(value: diaryList)
    lazy var deletedPageListSubject = BehaviorSubject<[DeletedPageCellModel]>(value: deletedPageList)
    lazy var pageListSubject = BehaviorSubject<[PaperModel]>(value: paperList)
    
    var diaryList: [DiaryInfoModel] = [
        DiaryInfoModel(id: "Diary_0", color: .DYRed, title: "1번 다이어리", totalPage: 0, password: "1234"),
        DiaryInfoModel(id: "Diary_1", color: .DYBlue, title: "2번 다이어리", totalPage: 0, password: "1234"),
        DiaryInfoModel(id: "Diary_2", color: .DYGreen, title: "3번 다이어리", totalPage: 0, password: "1234"),
        DiaryInfoModel(id: "Diary_3", color: .DYRed, title: "4번 다이어리", totalPage: 0, password: "1234"),
        DiaryInfoModel(id: "Diary_4", color: .DYBlue, title: "5번 다이어리", totalPage: 0, password: "1234"),
        DiaryInfoModel(id: "Diary_5", color: .DYGreen, title: "6번 다이어리", totalPage: 0, password: "1234")
    ]
    
    var deletedPageList: [DeletedPageCellModel] = [
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .cornell,
                             diaryName: "1번 다이어리",
                             deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .daily(date: Date()),
                             diaryName: "2번 다이어리",
                             deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .cornell,
                             diaryName: "3번 다이어리",
                             deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .daily(date: Date()),
                             diaryName: "4번 다이어리",
                             deletedDate: Date())
    ]
    
    

    var paperList: [PaperModel] = [

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
        pageListSubject.onNext(paperList)
    }

    func deleteDeletedPage(_ page: DeletedPageCellModel) {
        // TODO: - 임시로 다이어리 이름으로 비교하지만 추후에 데이터 연동 필요
        guard let index = deletedPageList.firstIndex(where: { $0.diaryName == page.diaryName }) else { return }
        paperList.remove(at: index)
        pageListSubject.onNext(paperList)
    }

    func deleteAllPage() {
        paperList = []
        pageListSubject.onNext(paperList)
    }
    
    func deleteAllDeletedPage() {
        deletedPageList = []
        deletedPageListSubject.onNext(deletedPageList)
    }

// MARK: - Diary

    func addDiary(_ diary: DiaryInfoModel) {
        diaryList.append(diary)
        diaryListSubject.onNext(diaryList)
    }

    func deleteDiary(_ diary: DiaryInfoModel) {
        guard let index = diaryList.firstIndex(where: { $0.id == diary.id }) else { return }
        diaryList.remove(at: index)
        diaryListSubject.onNext(diaryList)
    }

    func deleteAllDiary() {
        diaryList = []
        diaryListSubject.onNext(diaryList)
    }

// MARK: -Paper
    
    func addPaper(_ model: PaperModel) {
        paperList.append(model)
        pageListSubject.onNext(paperList)
    }

    func deletePaper(_ model: PaperModel) {
        guard let index = paperList.firstIndex(where: { $0.id == model.id }) else { return }
        paperList.remove(at: index)
        pageListSubject.onNext(paperList)
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
        pageListSubject.onNext(paperList)
    }

    func addPaperThumbnail(id: String, thumbnail: UIImage?) {
        guard let index = paperList.firstIndex(where: { $0.id == id }) else { return }
        paperList[index].thumbnail = thumbnail?.jpegData(compressionQuality: .greatestFiniteMagnitude)
    }
}
