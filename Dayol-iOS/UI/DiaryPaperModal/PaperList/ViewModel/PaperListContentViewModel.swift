//
//  PaperListContentViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/02.
//

import RxSwift

class PaperListContentViewModel {
    typealias CellModel = PaperModalModel.PaperListCellModel
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

    var cellModels: [CellModel] {
        return DYTestData.shared.paperList.map {
            CellModel(id: $0.id, isStarred: false, paperStyle: $0.paperStyle, paperType: $0.paperType, thumbnail: $0.thumbnail)
        }
    }

    var paperModels: [PaperModel] {
        DYTestData.shared.paperList
    }

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        DYTestData.shared.reorderPaper(from: sourceIndex, to: destinationIndex)
    }
}
