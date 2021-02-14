//
//  DiaryListTestData.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/08.
//

import Foundation
import RxSwift

class DiaryListTestData {
    static let shared = DiaryListTestData()
    
    var diaryList: [DiaryCoverModel] = [
        DiaryCoverModel(coverColor: .DYRed, title: "1번 다이어리", totalPage: 3, password: "1234"),
        DiaryCoverModel(coverColor: .DYBlue, title: "2번 다이어리", totalPage: 2, password: "1234"),
        DiaryCoverModel(coverColor: .DYGreen, title: "3번 다이어리", totalPage: 5, password: "1234"),
        DiaryCoverModel(coverColor: .DYRed, title: "1번 다이어리", totalPage: 3, password: "1234"),
        DiaryCoverModel(coverColor: .DYBlue, title: "2번 다이어리", totalPage: 2, password: "1234"),
        DiaryCoverModel(coverColor: .DYGreen, title: "3번 다이어리", totalPage: 5, password: "1234")
    ]
    
    lazy var diaryListSubject = BehaviorSubject<[DiaryCoverModel]>(value: diaryList)
    
    @discardableResult
    func create(diary: DiaryCoverModel) -> Observable<DiaryCoverModel> {
        diaryList.append(diary)
        diaryListSubject.onNext(diaryList)
        
        return Observable.just(diary)
    }
}
