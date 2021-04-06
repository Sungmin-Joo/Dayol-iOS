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
    let disposeBag = DisposeBag()

    init(papers: [CellModel]) {
        bind()
    }
    
    func bind() {
        DYTestData.shared.pageListSubject
            .subscribe(onNext: { [weak self] diary in
                guard let self = self else { return }
                guard let pages = diary[safe: 0]?.paperList else { return }
                
                self.papers = pages.map {
                    CellModel(id: $0.id, isStarred: false, paperStyle: $0.paperStyle, paperType: $0.paperType)
                }
                self.paperListEvent.onNext(.fetch)
            })
            .disposed(by: disposeBag)
    }

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        // TODO: Temporary Logic
        DYTestData.shared.reorderPage(from: sourceIndex, to: destinationIndex)
    }

}
