//
//  Array+extension.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
