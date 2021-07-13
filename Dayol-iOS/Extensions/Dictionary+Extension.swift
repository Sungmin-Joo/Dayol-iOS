//
//  Dictionary+Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/07/10.
//

import Foundation

extension Dictionary {
    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
