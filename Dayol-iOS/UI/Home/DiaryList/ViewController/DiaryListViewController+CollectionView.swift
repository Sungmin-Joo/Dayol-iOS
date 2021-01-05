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
        diaryListCell.isEditMode = isEditMode

        return diaryListCell
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }

}

// MARK: - UICollectionView Reorder

extension DiaryListViewController {

    @objc func didRecongizeLongPress(_ recog: UIGestureRecognizer) {
        guard viewModel.diaryList.count > 1 else { return }
        let point = recog.location(in: collectionView)
        switch recog.state {
        case .began:
            guard
                let indexPath = collectionView.indexPathForItem(at: point),
                isEditMode == false
            else {
                collectionView.cancelInteractiveMovement()
                return
            }

            isEditMode = true
            startEditMode(indexPath) { [weak self] in
                guard let self = self else { return }
                self.canStartInteractiveMovement = true
                self.currentEditIndex = indexPath
                self.collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            guard isEditMode, canStartInteractiveMovement else { return }
            collectionView.updateInteractiveMovementTargetPosition(point)
        case .ended:
            isEditMode = false
            canStartInteractiveMovement = false
            endEditMode { [weak self] in
                guard let self = self else { return }
                self.collectionView.endInteractiveMovement()
            }
        default:
            isEditMode = false
            canStartInteractiveMovement = false
            collectionView.cancelInteractiveMovement()
            endEditMode()
        }
    }

    private func startEditMode(_ indexPath: IndexPath, completion: (() -> Void)? = nil) {
        collectionView.visibleCells.enumerated().forEach { index, cell in
            guard let diaryCell = cell as? DiaryListCell else { return }
            diaryCell.isEditMode = true
        }

        if let diaryCell = collectionView.cellForItem(at: indexPath) as? DiaryListCell {
            diaryCell.diaryCoverView.alpha = 1
        }
        
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: false) { _ in
            completion?()
        }
    }

    private func endEditMode(completion: (() -> Void)? = nil) {
        collectionView.visibleCells.forEach { cell in
            guard let diaryCell = cell as? DiaryListCell else { return }
            diaryCell.isEditMode = false
        }
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: false) { _ in
            completion?()
        }
    }
}
