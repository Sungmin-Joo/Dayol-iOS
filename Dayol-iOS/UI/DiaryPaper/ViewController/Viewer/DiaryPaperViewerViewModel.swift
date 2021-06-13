//
//  DiaryPaperViewerViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/08.
//

import Foundation
import RxSwift

class DiaryPaperViewerViewModel {
    private let model: DiaryPaperViewerModel
    private let coverModel: Diary

    var diaryId: String {
        return coverModel.id
    }

    var coverHex: String {
        return coverModel.colorHex
    }

    var title: Observable<String> {
        return model.diaryTitle.asObservable()
    }

    func paperList(diaryId: String) -> Observable<[PaperModel]> {
        return model.innerModelsSubject
            .map { $0.filter { $0.diaryId == diaryId } }
            .asObservable()
    }

    func addPaper(_ type: PaperType, style: PaperStyle) {
        guard model.contain(paperType: type) == false else { return }
        let paper = PaperModel(id: DYTestData.shared.currentPaperId,
                               diaryId: coverModel.id,
                               paperStyle: style,
                               paperType: type,
                               numberOfPapers: 1,
                               drawModelList: DrawModel()
        )
        model.add(paper: paper)
    }

    func findModels(type: PaperType) -> [PaperModel] {
        var inners = [PaperModel]()
        model.innerModels.forEach { paper in
            if case paper.paperType = type {
                inners.append(paper)
            }
        }

        return inners
    }

    init(coverModel: Diary) {
        self.coverModel = coverModel
        self.model = DiaryPaperViewerModel(coverModel: coverModel)
    }
}
