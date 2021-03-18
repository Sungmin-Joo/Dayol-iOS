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
        guard let diaryInfo = viewModel.diaryList[safe: indexPath.item] else { return }
        showPasswordViewController(diaryCover: diaryInfo)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }

        // 한 칸의 셀 이동 == 셀 + 마진 값 만큼 오프셋이 이동
        let cellWidthMargin = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let idx = round((offset.x + collectionView.contentInset.left) / cellWidthMargin)

        if let indexX = offsetX(index: Int(idx)) {
            offset.x = indexX
            targetContentOffset.pointee = offset
            currentIndex = Int(idx)
        }

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
        hasReorder = true
        viewModel.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)

        let idx = destinationIndexPath.row

        if let offsetX = offsetX(index: idx) {
            let offset = CGPoint(x: offsetX, y: 0)
            collectionView.setContentOffset(offset, animated: true)
        }
    }

}

// MARK: - ScrollView Movement

extension DiaryListViewController {

    func offsetX(index: Int) -> CGFloat? {
        guard
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else {
            return nil
        }

        let cellWidthMargin = layout.itemSize.width + layout.minimumLineSpacing
        let offsetX = CGFloat(index) * cellWidthMargin - collectionView.contentInset.left

        return offsetX
    }

    func moveToIndex(_ index: Int, animated: Bool = true) {
        guard let offsetX = offsetX(index: index) else { return }
        let offset = CGPoint(x: offsetX, y: 0)
        collectionView.setContentOffset(offset, animated: animated)
        currentIndex = index
    }
}

// MARK: - UICollectionView Reorder

extension DiaryListViewController {

    @objc func didRecongizeLongPress(_ recog: UIGestureRecognizer) {
        guard viewModel.diaryList.count > 1 else { return }
        let point = recog.location(in: collectionView)
        switch recog.state {
        case .began:
            let validRange = currentIndex - 1...currentIndex + 1
            guard
                let indexPath = collectionView.indexPathForItem(at: point),
                isEditMode == false,
                validRange.contains(indexPath.row)
            else {
                collectionView.cancelInteractiveMovement()
                return
            }


            isEditMode = true
            startEditMode(indexPath) { [weak self] in
                guard let self = self else { return }
                self.hasReorder = false
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

                // 순서 변경 인터랙션을 수행했지만 결국 순서를 바꾸지 않은 경우
                if self.hasReorder == false, let currentEditIndex = self.currentEditIndex {
                    self.moveToIndex(currentEditIndex.row, animated: false)
                }
            }
        default:
            isEditMode = false
            canStartInteractiveMovement = false
            collectionView.cancelInteractiveMovement()
            endEditMode()

            if let currentEditIndex = currentEditIndex {
                moveToIndex(currentEditIndex.row)
            }
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
