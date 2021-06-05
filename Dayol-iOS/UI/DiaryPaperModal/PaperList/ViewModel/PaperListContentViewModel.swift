//
//  PaperListContentViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/02.
//

import RxSwift

class PaperListContentViewModel {
    typealias CellModel = PaperModalModel.PaperListCellModel
    typealias PaperModel = DiaryInnerModel.PaperModel
    enum PaperListevent {

        enum Action {
            case share
            case starred
            case copy
            case delete
        }

        case add
        case fetch
        case reorder(at: Int, to: Int)
        case activity(action: Action, at: Int)
    }
    private(set) var cellModels: [CellModel] = []
    var paperModels: [PaperModel] {
        DYTestData.shared.paperList
    }
    let paperListEvent = ReplaySubject<PaperListevent>.createUnbounded()
    let disposeBag = DisposeBag()

    init() {
        self.cellModels = paperModels.map {
            CellModel(id: $0.id, isStarred: false, paperStyle: $0.paperStyle, paperType: $0.paperType, thumbnail: $0.thumbnail)
        }
    }

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        DYTestData.shared.reorderPaper(from: sourceIndex, to: destinationIndex)
    }

}
