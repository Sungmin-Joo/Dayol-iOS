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
    private let diaryId: String
    private let disposeBag = DisposeBag()

    let testDrawModel = DYTestData.testDrawModel
    var papers: [Paper] = DYTestData.shared.paperList
    let papersSubject = DYTestData.shared.paperListSubject
    let diaryTitle = BehaviorSubject<String>(value: "")
    let changeFavorite = PublishSubject<Bool>()
    let updatePapers = BehaviorSubject<[Paper]>(value: [])

    init(coverModel: Diary) {
        self.diaryId = coverModel.id
        diaryTitle.onNext(coverModel.title)
        bind()
    }

    private func bind() {
        DYTestData.shared.paperListSubject
            .subscribe(onNext: { [weak self] _ in
                self?.needsUpdatePapers()
            })
            .disposed(by: disposeBag)
    }

    private func needsUpdatePapers() {
        let filteredPaper = DYTestData.shared.paperList.filter({ $0.diaryId == diaryId })
        updatePapers.onNext(filteredPaper)
    }

    func add(paper: Paper) {
        DYTestData.shared.addPaper(paper)
    }

    func deletePaper(paperId: String) {
        DYTestData.shared.deletePaper(with: paperId)
    }
    
    func deleteAll() {
        DYTestData.shared.deleteAllPage()
    }

    func updateFavorite(paperId: String, isFavorite: Bool) {
        DYTestData.shared.updateFavorite(paperId: paperId, isFavorite: isFavorite)

        changeFavorite.onNext(isFavorite)
    }

    func contain(paperType: PaperType) -> Bool {
        return DYTestData.shared.paperList.contains(where: { paper in
            if case paper.type = paperType {
                return true
            }
            return false
        })
    }

}
