//
//  DiaryListViewController+CollectionView.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import UIKit

// MARK: - UICollectionView

extension DiaryListViewController: UICollectionViewDelegate {

}

extension DiaryListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewModel.diaryList.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryListCell.identifier, for: indexPath)

        guard
            let viewModel = viewModel.diaryList[safe: indexPath.row],
            let diaryListCell = cell as? DiaryListCell
        else {
            return UICollectionViewCell()
        }
        diaryListCell.viewModel = viewModel
        return diaryListCell
    }

}
