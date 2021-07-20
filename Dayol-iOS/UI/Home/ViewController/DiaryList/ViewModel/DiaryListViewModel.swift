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

    var diaryList: [Diary] {
        return DiaryManager.shared.diaryList
    }
    var diaryFetchEvent = ReplaySubject<Void>.createUnbounded()

    init() {
        bind()
    }
    
    private func bind() {
        DiaryManager.shared.needsUpdateDiaryList
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.diaryFetchEvent.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

extension DiaryListViewModel {

    func deleteDiary(at index: Int) {
        guard let diary = diaryList[safe: index] else { return }
        DiaryManager.shared.deleteDiary(id: diary.id)
    }

    func updateDiaryLock(at index: Int, isLock: Bool) {
        guard var diary = diaryList[safe: index] else { return }
        diary.isLock = isLock
        DiaryManager.shared.updateDiary(diary)
        DiaryManager.shared.fetchDiaryList()
    }

}

// MARK: - Diary List

extension DiaryListViewModel {

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        DiaryManager.shared.updateDiaryOrder(at: sourceIndex, to: destinationIndex)
    }

}
