//
//  TimeInterval+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/30.
//

import Foundation

extension TimeInterval {
    var asDate: Date {
        return Date(timeIntervalSince1970: self)
    }
}
