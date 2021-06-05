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
struct DiaryInnerModel {

    // 다이어리 내부 다양한 종류의 메모에 대한 테스트 모델
    struct PaperModel {
        let id: Int
        let paperStyle: PaperStyle
        let paperType: PaperType
        let paperTitle: String
        var numberOfPapers: Int
        // TODO: - 속지 추가 스펙이 있어서 [DrawModel] 로 변경되어야 할 것 같습니다.
        var drawModelList: DrawModel
        var thumbnail: UIImage?
        let updateThumbnail = PublishSubject<Void>()

        init(id: Int, paperStyle: PaperStyle, paperType: PaperType, numberOfPapers: Int, drawModelList: DrawModel) {
            self.id = id
            self.paperType = paperType
            self.paperStyle = paperStyle
            self.numberOfPapers = numberOfPapers
            self.drawModelList = drawModelList
            self.paperTitle = paperType.title
        }

        mutating func setThumbnail(_ image: UIImage?) {
            self.thumbnail = image
        }
    }

    let diaryID: Int
    var paperList: [PaperModel]
}

class DYTestData {
    static let shared = DYTestData()
    static let testDrawModel = DrawModel(lines: [], stickers: [], labels: [])

    var currentDiaryId: Int {
        diaryList.count
    }

    var currentPaperId: Int {
        paperList.count
    }

    lazy var diaryListSubject = BehaviorSubject<[DiaryInfoModel]>(value: diaryList)
    lazy var deletedPageListSubject = BehaviorSubject<[DeletedPageCellModel]>(value: deletedPageList)
    lazy var pageListSubject = BehaviorSubject<[DiaryInnerModel.PaperModel]>(value: paperList)
    
    var diaryList: [DiaryInfoModel] = [
        DiaryInfoModel(id: 0, color: .DYRed, title: "1번 다이어리", totalPage: 3, password: "1234"),
        DiaryInfoModel(id: 1, color: .DYBlue, title: "2번 다이어리", totalPage: 2, password: "1234"),
        DiaryInfoModel(id: 2, color: .DYGreen, title: "3번 다이어리", totalPage: 5, password: "1234"),
        DiaryInfoModel(id: 3, color: .DYRed, title: "4번 다이어리", totalPage: 3, password: "1234"),
        DiaryInfoModel(id: 4, color: .DYBlue, title: "5번 다이어리", totalPage: 2, password: "1234"),
        DiaryInfoModel(id: 5, color: .DYGreen, title: "6번 다이어리", totalPage: 5, password: "1234")
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
    
    

    var paperList: [DiaryInnerModel.PaperModel] = [

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
    
    func addPaper(_ model: DiaryInnerModel.PaperModel) {
        paperList.append(model)
        pageListSubject.onNext(paperList)
    }

    func deletePaper(_ model: DiaryInnerModel.PaperModel) {
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

    func addPaperThumbnail(id: Int, thumbnail: UIImage?) {
        guard let index = paperList.firstIndex(where: { $0.id == id }) else { return }
        paperList[index].thumbnail = thumbnail

        pageListSubject.onNext(paperList)
    }
}
