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
            .subscribe(onNext: { [weak self] resultPapers in
                guard let self = self else { return }
                
                self.papers = resultPapers.map {
                    CellModel(id: $0.id, isStarred: false, paperStyle: $0.paperStyle, paperType: $0.paperType, thumbnail: $0.thumbnail)
                }
                self.paperListEvent.onNext(.fetch)
            })
            .disposed(by: disposeBag)
    }

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        // TODO: Temporary Logic
        DYTestData.shared.reorderPaper(from: sourceIndex, to: destinationIndex)
    }

}
