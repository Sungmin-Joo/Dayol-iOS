//
//  DiaryPaperViewerViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/08.
//

import Foundation
import RxSwift

class DiaryPaperViewerViewModel {
    enum PaperUpdateEvent {
        case add
        case delete
        case load
    }

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

    var didFavoriteChanged: Observable<Bool> {
        return model.changeFavorite
    }

    var didUpdatedPaper: Observable<[Paper]> {
        return model.updatePapers
    }

    var currentPaperEvent: PaperUpdateEvent = .load

    init(coverModel: Diary) {
        self.coverModel = coverModel
        self.model = DiaryPaperViewerModel(coverModel: coverModel)
    }

    func addPaper(_ type: PaperType, orientation: Paper.PaperOrientation, date: Date = .now) {
        // TODO: 모델 init 간편화 필요
        // TODO: Model을 따로두고 Model이 Entity와 소통하도록 변경해야함
        currentPaperEvent = .add
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

    func deletePaper(_ paperId: String) {
        currentPaperEvent = .delete
        model.deletePaper(paperId: paperId)
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

    func updateFavorite(paperId: String, _ isFavorite: Bool) {
        model.updateFavorite(paperId: paperId, isFavorite: isFavorite)
    }
}
