//
//  DiaryPaperViewerViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/08.
//

import UIKit
import RxSwift

class DiaryPaperViewerViewModel {
    private let model: DiaryPaperViewerModel
    private let coverModel: DiaryInfoModel
    
    var title: Observable<String> {
        return model.diaryTitle.asObservable()
    }
    
    var paperList: Observable<[DiaryInnerModel.PaperModel]> {
        return model.innerModelsSubject.asObservable()
    }
    
    var coverColor: UIColor {
        return coverModel.color.coverColor
    }

    func addPaper(_ type: PaperType, style: PaperStyle) {
        guard model.contain(paperType: type) == false else { return }
        let paper = DiaryInnerModel.PaperModel(id: model.innerModels.count + 1,
                                               paperStyle: style,
                                               paperType: type,
                                               numberOfPapers: 1,
                                               drawModelList: DrawModel()
        )
        model.add(paper: paper)
    }

    func findModels(type: PaperType) -> [DiaryInnerModel.PaperModel] {
        var inners = [DiaryInnerModel.PaperModel]()
        model.innerModels.forEach { paper in
            if case paper.paperType = type {
                inners.append(paper)
            }
        }

        return inners
    }

    init(coverModel: DiaryInfoModel) {
        self.coverModel = coverModel
        self.model = DiaryPaperViewerModel(coverModel: coverModel)
    }
}
