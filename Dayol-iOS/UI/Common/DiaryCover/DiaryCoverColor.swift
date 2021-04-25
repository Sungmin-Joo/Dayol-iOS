//
//  DiaryCoverColor.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/04.
//

import UIKit

struct CoverColorSet {
    let red: Int
    let green: Int
    let blue: Int
}

enum DiaryCoverColor: CaseIterable {
    case DYRed
    case DYOrange
    case DYYellow
    case DYGreen
    case DYMint
    case DYSkyblue
    case DYBlue
    case DYPurple
    case DYPink
    case DYLightBrown
    case DYBrown
    case DYDark
    case DYDarkYellow
    case DYDarkGreen
    case DYDarkBlue
    case DYGrey
    
    private var colorSet: CoverColorSet {
        switch self {
        case .DYRed:
            return CoverColorSet(red: 231, green: 76, blue: 67)
        case .DYOrange:
            return CoverColorSet(red: 237, green: 122, blue: 81)
        case .DYYellow:
            return CoverColorSet(red: 255, green: 178, blue: 67)
        case .DYGreen:
            return CoverColorSet(red: 57, green: 161, blue: 103)
        case .DYMint:
            return CoverColorSet(red: 63, green: 174, blue: 179)
        case .DYSkyblue:
            return CoverColorSet(red: 48, green: 138, blue: 201)
        case .DYBlue:
            return CoverColorSet(red: 40, green: 106, blue: 174)
        case .DYPurple:
            return CoverColorSet(red: 108, green: 89, blue: 173)
        case .DYPink:
            return CoverColorSet(red: 255, green: 145, blue: 184)
        case .DYLightBrown:
            return CoverColorSet(red: 200, green: 144, blue: 123)
        case .DYBrown:
            return CoverColorSet(red: 187, green: 120, blue: 76)
        case .DYDark:
            return CoverColorSet(red: 0, green: 0, blue: 0)
        case .DYDarkYellow:
            return CoverColorSet(red: 137, green: 127, blue: 109)
        case .DYDarkGreen:
            return CoverColorSet(red: 92, green: 115, blue: 104)
        case .DYDarkBlue:
            return CoverColorSet(red: 75, green: 92, blue: 115)
        case .DYGrey:
            return CoverColorSet(red: 72, green: 77, blue: 85)
        }
    }
    
    var coverColor: UIColor {
        return UIColor(decimalRed: colorSet.red, green: colorSet.green, blue: colorSet.blue)
    }
    
    var lockerColor: UIColor {
        let redSum = 10
        let greenSum = 20
        let blueSum = 25
        let lockerRed = colorSet.red + redSum > 255 ? 255 : colorSet.red + redSum
        let lockerGreen = colorSet.green + greenSum > 255 ? 255 : colorSet.green + greenSum
        let lockerBlue = colorSet.blue + blueSum > 255 ? 255 : colorSet.blue + blueSum
        
        return UIColor(decimalRed: lockerRed, green: lockerGreen, blue: lockerBlue)
    }
}

extension DiaryCoverColor {

    static var penColorPreset: [DiaryCoverColor] {
        // TODO: 컬러피커에서 등록한 컬러를 추가하는 로직 필요
        let presetColors = [
            DiaryCoverColor.DYDark,
            DiaryCoverColor.DYRed,
            DiaryCoverColor.DYYellow,
            DiaryCoverColor.DYGreen,
            DiaryCoverColor.DYMint,
            DiaryCoverColor.DYSkyblue,
            DiaryCoverColor.DYBlue
        ]
        return presetColors
    }

}
