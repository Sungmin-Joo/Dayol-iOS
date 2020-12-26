//
//  DiaryListViewController+bind.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import RxSwift

// MARK: - Bind

extension DiaryListViewController {
    func bind() {
        viewModel.diaryEvent
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .fetch(let isEmpty):
                    guard isEmpty == false else {
                        self.showEmptyView()
                        return
                    }
                    self.hideEmptyView()
                    self.collectionView.reloadData()
                case .insert(let index):
                    print(index)
                case .delete(let index):
                    print(index)
                case .update(let index):
                    print(index)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Update

extension DiaryListViewController {

    private func showEmptyView() {
        emptyView.isHidden = false
    }

    private func hideEmptyView() {
        emptyView.isHidden = true
    }

}
