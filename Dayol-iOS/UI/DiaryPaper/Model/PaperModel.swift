//
//  PaperModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit

enum CommonPaperDesign {
    static let defaultBGColor = UIColor.white
    static let borderColor = UIColor(decimalRed: 233, green: 233, blue: 233)
}

enum PaperStyle {
    case monthly
    case weekly
    case daily
    case cornell
    case muji
    case grid
    case four
    case tracker
}

struct Line {
    // drawing object에 대한 모델
}

struct Sticker {
    // sticker object에 대한 모델
}

struct Label {
    // label object에 대한 모델
}

struct DrawModel {
    var lines: [Line] = []
    var stickers: [Sticker] = []
    var labels: [Label]  = []
}
