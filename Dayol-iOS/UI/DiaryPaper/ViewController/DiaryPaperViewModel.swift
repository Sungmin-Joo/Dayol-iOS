//
//  DiaryPaperViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/08.
//

import Foundation
import RxSwift

class DiaryPaperViewModel {
    private let model: DiaryPaperModel
    private let coverModel: DiaryCoverModel
    
    var title: Observable<String> {
        return model.diaryTitle.asObservable()
    }
    
    var paperList: Observable<[DiaryInnerModel]> {
        return model.innerModelsSubject.asObservable()
    }
    
    init(coverModel: DiaryCoverModel) {
        self.coverModel = coverModel
        self.model = DiaryPaperModel(coverModel: coverModel)
    }
}
