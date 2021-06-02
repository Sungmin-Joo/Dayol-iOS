//
//  UICollectionView+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.className)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cellClass.className, for: indexPath) as! T
    }
}

