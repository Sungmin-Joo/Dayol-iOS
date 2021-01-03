//
//  DiaryListViewController+CollectionView.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import UIKit

// MARK: - UICollectionView

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel.diaryList[safe: indexPath.row] else { return }
        
        let passwordViewCotroller = PasswordViewController(diaryColor: viewModel.coverColor, password: "1234")
        present(passwordViewCotroller, animated: true, completion: nil)
    }
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
