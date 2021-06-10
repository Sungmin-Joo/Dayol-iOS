//
//  UITableView+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/01.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cellClass.className, for: indexPath) as! T
    }
}
