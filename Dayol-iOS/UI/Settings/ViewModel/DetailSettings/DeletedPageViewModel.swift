//
//  DeletedPageViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/14.
//

import RxSwift

class DeletedPageViewModel {

    enum DeletedPageEvent {
        case fetch(isEmpty: Bool)
        case deleteAll
    }
    let deletedPageEvent = ReplaySubject<DeletedPageEvent>.createUnbounded()
    private(set) var diaryList: [DeletedPageCellModel] = []

    init() {
        fetchDeletedPage()
    }

    func delete(at index: Int) {

    }

    func deleteAll() {
        diaryList = []
        deletedPageEvent.onNext(.deleteAll)
    }

    func restore(at index: Int) {

    }

}

// MARK: - private extension

private extension DeletedPageViewModel {

    func fetchDeletedPage() {
        diaryList = [
            DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .cornell,
                             diaryName: "1번 다이어리",
                             deletedDate: Date()),
            DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .daily,
                             diaryName: "2번 다이어리",
                             deletedDate: Date()),
        ]
        deletedPageEvent.onNext(.fetch(isEmpty: false))
    }

}
