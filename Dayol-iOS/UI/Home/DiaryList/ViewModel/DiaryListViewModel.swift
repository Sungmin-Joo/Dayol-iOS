//
//  DiaryViewModel.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import RxSwift

class DiaryListViewModel {

    enum DiaryListEvent {
        case fetch(isEmpty: Bool)
        case insert(index: Int)
        case delete(index: Int)
        case update(index: Int)
    }

    private(set) var diaryList: [DiaryCoverModel] = []
    var diaryEvent = ReplaySubject<DiaryListEvent>.createUnbounded()

    init() {
        fetchDiaryList()
    }
}

// MARK: - Fetch

extension DiaryListViewModel {

    private func fetchDiaryList() {
        // db에서 다이어리 가져오기
        diaryList = [
            DiaryCoverModel(coverColor: .red, title: "1번 다이어리", totalPage: 3),
            DiaryCoverModel(coverColor: .blue, title: "2번 다이어리", totalPage: 2),
            DiaryCoverModel(coverColor: .green, title: "3번 다이어리", totalPage: 5),
            DiaryCoverModel(coverColor: .red, title: "1번 다이어리", totalPage: 3),
            DiaryCoverModel(coverColor: .blue, title: "2번 다이어리", totalPage: 2),
            DiaryCoverModel(coverColor: .green, title: "3번 다이어리", totalPage: 5)
        ]

        let isEmpty = (diaryList.count == 0)
        diaryEvent.onNext(.fetch(isEmpty: isEmpty))
    }

    // TODO: - 실 데이터와 연동
    private func getMockData() {

    }

}

// MARK: - Diary List

extension DiaryListViewModel {

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard let sourceModel = diaryList[safe: sourceIndex] else {
            // 로거 추가 필요
            debugPrint("[DiaryList] wrong move index")
            return
        }

        if sourceIndex > destinationIndex {
            diaryList.remove(at: sourceIndex)
            diaryList.insert(sourceModel, at: destinationIndex)
        } else {
            diaryList.insert(sourceModel, at: destinationIndex + 1)
            diaryList.remove(at: sourceIndex)
        }
    }

}
