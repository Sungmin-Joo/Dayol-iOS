//
//  DiaryPaperViewerModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/08.
//

import Foundation
import RxSwift

class DiaryPaperViewerModel {
    /// DiaryPageTestData는 DB라고 생각할 것
    /// DB에 요청할 파라미터는 추후 논의 일단은 void로 둠(init)
    
    let testDrawModel = DYTestData.testDrawModel
    var innerModels: [PaperModel] = DYTestData.shared.paperList
    let innerModelsSubject = DYTestData.shared.pageListSubject
    let diaryTitle = BehaviorSubject<String>(value: "")

    init(coverModel: DiaryInfoModel) {
        diaryTitle.onNext(coverModel.title)
    }
    
    @discardableResult
    func add(paper: PaperModel) -> Observable<PaperModel> {
        DYTestData.shared.addPaper(paper)
        
        return Observable.just(paper)
    }
    
    @discardableResult
    func delete(paper: PaperModel) -> Observable<PaperModel> {
        DYTestData.shared.deletePaper(paper)
        
        return Observable.just(paper)
    }
    
    func deleteAll() {
        DYTestData.shared.deleteAllPage()
    }

    func contain(paperType: PaperType) -> Bool {
        return DYTestData.shared.paperList.contains(where: { $0.paperType  ==  paperType })
    }

}
