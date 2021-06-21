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

    func addPaper(_ type: PaperType, orientation: Paper.PaperOrientation, date: Date = .now) {
        // TODO: 모델 init 간편화 필요
        // TODO: Model을 따로두고 Model이 Entity와 소통하도록 변경해야함

        let paperSize = PaperOrientationConstant.size(orentantion: orientation)
        let paper = Paper(id: DYTestData.shared.currentPaperId,
                          diaryId: diaryId,
                          title: type.typeName,
                          pageCount: 1,
                          orientation: orientation,
                          type: type,
                          width: Float(paperSize.width),
                          height: Float(paperSize.height),
                          thumbnail: nil,
                          drawCanvas: Data(),
                          contents: [],
                          date: date,
                          isFavorite: false)
        model.add(paper: paper)
    }

    func findModels(type: PaperType) -> [Paper] {
        var inners = [Paper]()
        model.papers.forEach { paper in
            if case paper.type = type {
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
