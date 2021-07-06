//
//  Diary.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/13.
//

import Foundation

struct Diary {
    let id: String // D1, D2
    // TODO: - 패스워드 모델 정해진 후 재 구현(isLock)
    var isLock: Bool = false
    var index: Int32
    let title: String
    let colorHex: String

    var hasLogo: Bool
    var thumbnail: Data
    var drawCanvas: Data
    var contents: [DecorationItem]
}
