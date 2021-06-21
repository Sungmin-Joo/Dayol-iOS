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
        case nanumsquare
        case nanumsquareround
        case dahaeng
        case baeeunhye
        case himnaera
        case ridibatang
        case binggrae
        case binggraesamanco
        case gmarketSans

        var thumbnailName: String? {
            guard self != .system else { return nil }
            return "img_thumb_\(self.rawValue)"
        }
    }
}

class TextStyleFontViewModel {
    let fonts: [Font] = Font.allCases
    let currentFontName = ReplaySubject<String>.createUnbounded()
}
