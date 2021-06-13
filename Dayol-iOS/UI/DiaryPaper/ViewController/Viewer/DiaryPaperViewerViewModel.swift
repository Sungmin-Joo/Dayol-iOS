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

    func paperList(diaryId: String) -> Observable<[Paper]> {
        return model.papersSubject
            .map { $0.filter { $0.diaryId == diaryId } }
            .asObservable()
    }

    func addPaper(_ type: PaperType, style: PaperStyle) {
        guard model.contain(paperType: type) == false else { return }
        // TODO: 모델 init 간편화 필요
        // TODO: Model을 따로두고 Model이 Entity와 소통하도록 변경해야함
        let paper = Paper(id: DYTestData.shared.currentPaperId,
                          diaryId: diaryId,
                          title: type.title,
                          pageCount: 1,
                          orientation: style.entityValue,
                          type: type.entityValue,
                          width: Float(style.size.width),
                          height: Float(style.size.height),
                          thumbnail: nil,
                          drawCanvas: Data(),
                          contents: [],
                          date: type.date)
//        let paper = PaperModel(id: DYTestData.shared.currentPaperId,
//                               diaryId: coverModel.id,
//                               paperStyle: style,
//                               paperType: type,
//                               numberOfPapers: 1,
//                               drawModelList: DrawModel()
        model.add(paper: paper)
    }

    func findModels(type: PaperType) -> [Paper] {
        var inners = [Paper]()
        model.papers.forEach { paper in
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
