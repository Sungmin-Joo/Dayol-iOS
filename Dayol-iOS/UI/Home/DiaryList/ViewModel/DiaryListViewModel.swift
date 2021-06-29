//
//  DiaryViewModel.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import RxSwift

class DiaryListViewModel {
    private let disposeBag = DisposeBag()
    enum DiaryListEvent {
        case fetch(isEmpty: Bool)
    }

    private(set) var diaryList: [Diary] = []
    var diaryFetchEvent = ReplaySubject<Void>.createUnbounded()

    init() {
        bind()
    }
    
    private func bind() {
        DiaryDataHelper.shared.diaryListSubject
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.diaryList = model
                self.diaryFetchEvent.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

extension DiaryListViewModel {

    func deleteDiary(at index: Int) {
        guard let diary = diaryList[safe: index] else { return }
        DiaryDataHelper.shared.deleteDiary(id: diary.id)
    }

}

// MARK: - Diary List

extension DiaryListViewModel {

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard let sourceModel = diaryList[safe: sourceIndex] else {
            // 로거 추가 필요
            debugPrint("[DiaryList] wrong move index")
            return
        }

        if sourceIndex > destinationIndex {
            diaryList.remove(at: sourceIndex)
            diaryList.insert(sourceModel, at: destinationIndex)
        } else {
            diaryList.insert(sourceModel, at: destinationIndex + 1)
            diaryList.remove(at: sourceIndex)
        }
    }

}
