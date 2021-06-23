//
//  TextStyleFontViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/21.
//

import Foundation
import RxSwift

class TextStyleFontViewModel {
    let fonts: [Font] = Font.allCases
    let currentFontSubject: BehaviorSubject<Font>

    init(currentFontName: String?) {
        if let name = currentFontName, let font = Font(rawValue: name) {
            self.currentFontSubject = BehaviorSubject(value: font)
        } else {
            self.currentFontSubject = BehaviorSubject(value: .system)
        }
    }

    func didSelectedRow(at index: Int) {
        if let font = fonts[safe: index] {
            currentFontSubject.onNext(font)
        }
    }
}

// MARK: - Font Type

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

        var hasBoldFont: Bool {
            switch self {
            case .baeeunhye, .dahaeng, .himnaera, .ridibatang:
                return false
            case .nanumsquare, .nanumsquareround, .binggrae,
                 .binggraesamanco, .gmarketSans, .system:
                return true
            }
        }
    }
}
