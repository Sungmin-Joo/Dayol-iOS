//
//  DiaryPageListTestData.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/17.
//

import Foundation
import RxSwift

class DiaryPageListTestData {
    // 바뀔수 있음
    typealias PaperModel = PaperModalModel.PaperListCellModel
    static let shared = DiaryPageListTestData()
    
    // 바뀔수 있음
    var papers: [PaperModel] = [
        PaperModel(id: 0, isStarred: false, orientation: .landscape, style: .cornell),
        PaperModel(id: 1, isStarred: false, orientation: .portrait, style: .monthly),
        PaperModel(id: 2, isStarred: false, orientation: .landscape, style: .weekly),
        PaperModel(id: 3, isStarred: false, orientation: .landscape, style: .grid),
        PaperModel(id: 4, isStarred: false, orientation: .landscape, style: .muji),
        PaperModel(id: 5, isStarred: false, orientation: .landscape, style: .four)
    ]
    
    lazy var papersSubject = BehaviorSubject<[PaperModel]>(value: papers)
    
    @discardableResult
    func create(paper: PaperModel) -> Observable<PaperModel> {
        papers.append(paper)
        papersSubject.onNext(papers)
        
        return Observable.just(paper)
    }
    
    @discardableResult
    func delete(paper: PaperModel) -> Observable<PaperModel> {
        if let index = papers.firstIndex(where: { $0.id == paper.id }) {
            papers.remove(at: index)
        }
        papersSubject.onNext(papers)
        
        return Observable.just(paper)
    }
}
