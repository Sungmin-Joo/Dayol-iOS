//
//  TextStyleFontViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/21.
//

import Foundation
import RxSwift

extension TextStyleFontViewModel {
    enum Font: String, CaseIterable {
        case system
        case nanumsquare = "NanumSquare"
        case nanumsquareround = "NanumSquareRound"
        case dahaeng = "NanumDaHaengCe"
        case baeeunhye = "NanumBaeEunHyeCe"
        case himnaera = "NanumHimNaeRaNeunMarBoDan"
        case ridibatang = "RIDIBatang"
        case binggrae = "Binggrae"
        case binggraesamanco = "BinggraeSamanco"
        case gmarketSans = "GmarketSansTTFMedium"

        var thumbnailName: String? {
            guard self != .system else { return nil }
            return "img_thumb_\(self.rawValue)"
        }
    }
}

class TextStyleFontViewModel {
    let fonts: [Font] = Font.allCases
}
