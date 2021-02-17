//
//  DeletedPageListTestData.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/17.
//

import Foundation
import RxSwift

class DeletedPageListTestData {
    static let shared = DeletedPageListTestData()

    var pageList: [DeletedPageCellModel] = [
        DeletedPageCellModel(thumbnailImageName: "image",
                         paperType: .cornell,
                         diaryName: "1번 다이어리",
                         deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                         paperType: .daily,
                         diaryName: "2번 다이어리",
                         deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                         paperType: .cornell,
                         diaryName: "3번 다이어리",
                         deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                         paperType: .daily,
                         diaryName: "4번 다이어리",
                         deletedDate: Date())
    ]

    lazy var pageListSubject = BehaviorSubject<[DeletedPageCellModel]>(value: pageList)

    func addPage(_ page: DeletedPageCellModel) {
        pageList.append(page)
        pageListSubject.onNext(pageList)
    }

    func deletePage(_ page: DeletedPageCellModel) {
        guard let index = pageList.firstIndex(of: page) else { return }
        pageList.remove(at: index)
        pageListSubject.onNext(pageList)
    }

    func deleteAll() {
        pageList = []
        pageListSubject.onNext(pageList)
    }
}
