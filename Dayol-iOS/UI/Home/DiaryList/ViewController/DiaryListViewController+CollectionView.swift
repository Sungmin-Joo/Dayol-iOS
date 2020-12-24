//
//  DiaryListViewController+CollectionView.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import UIKit

private enum Design {
    static let collectionViewInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
    static let itemSize = CGSize(width: 278, height: 432)
}

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

extension DiaryListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Design.itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        // collectionView.bounds.width 를 사용하는 경우 기기 회전시 이 전 사이즈로 계산함
        // 우선 keyWindow의 값을 사용함으로 해결.
        let width = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.bounds.width ?? collectionView.bounds.width
        let itemWidth = Design.itemSize.width
        let horizontalInset = width / 2 - itemWidth / 2

        return UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }

}
