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
    private(set) var papers: [CellModel] = []
    let paperListEvent = ReplaySubject<PaperListevent>.createUnbounded()

    init() {
        // TODO: - 실데이터 연동
        papers = [
            CellModel(id: 0, isStarred: true, orientation: .landscape, style: .cornell),
            CellModel(id: 1, isStarred: true, orientation: .portrait, style: .muji),
            CellModel(id: 2, isStarred: false, orientation: .landscape, style: .monthly),
            CellModel(id: 3, isStarred: true, orientation: .portrait, style: .daily),
            CellModel(id: 4, isStarred: false, orientation: .landscape, style: .tracker),
            CellModel(id: 5, isStarred: true, orientation: .portrait, style: .four)
        ]
        paperListEvent.onNext(.fetch)
    }

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard let sourceModel = papers[safe: sourceIndex] else {
            // 로거 추가 필요
            debugPrint("[DiaryList] wrong move index")
            return
        }

        if sourceIndex > destinationIndex {
            papers.remove(at: sourceIndex)
            papers.insert(sourceModel, at: destinationIndex)
        } else {
            papers.insert(sourceModel, at: destinationIndex + 1)
            papers.remove(at: sourceIndex)
        }
        paperListEvent.onNext(.reorder(at: sourceIndex, to: destinationIndex))
    }

}
