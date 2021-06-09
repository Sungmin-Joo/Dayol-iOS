//
//  DYPaletteColor.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/04.
//

import UIKit

extension DYPaletteColor {
    struct ColorSet: Equatable {
        let red: Int
        let green: Int
        let blue: Int
    }
}

enum DYPaletteColor: Equatable {

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
    case custom(red: Int, green: Int, blue: Int)
    
    var colorSet: ColorSet {
        switch self {
        case .DYRed:
            return ColorSet(red: 231, green: 76, blue: 67)
        case .DYOrange:
            return ColorSet(red: 237, green: 122, blue: 81)
        case .DYYellow:
            return ColorSet(red: 255, green: 178, blue: 67)
        case .DYGreen:
            return ColorSet(red: 57, green: 161, blue: 103)
        case .DYMint:
            return ColorSet(red: 63, green: 174, blue: 179)
        case .DYSkyblue:
            return ColorSet(red: 48, green: 138, blue: 201)
        case .DYBlue:
            return ColorSet(red: 40, green: 106, blue: 174)
        case .DYPurple:
            return ColorSet(red: 108, green: 89, blue: 173)
        case .DYPink:
            return ColorSet(red: 255, green: 145, blue: 184)
        case .DYLightBrown:
            return ColorSet(red: 200, green: 144, blue: 123)
        case .DYBrown:
            return ColorSet(red: 187, green: 120, blue: 76)
        case .DYDark:
            return ColorSet(red: 0, green: 0, blue: 0)
        case .DYDarkYellow:
            return ColorSet(red: 137, green: 127, blue: 109)
        case .DYDarkGreen:
            return ColorSet(red: 92, green: 115, blue: 104)
        case .DYDarkBlue:
            return ColorSet(red: 75, green: 92, blue: 115)
        case .DYGrey:
            return ColorSet(red: 72, green: 77, blue: 85)
        case .custom(let red, let green, let blue):
            return ColorSet(red: red, green: green, blue: blue)
        }
    }
    
    var uiColor: UIColor {
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

extension DYPaletteColor {

    static var colorPreset: [DYPaletteColor] {
        return [
            DYPaletteColor.DYDark,
            DYPaletteColor.DYRed,
            DYPaletteColor.DYOrange,
            DYPaletteColor.DYYellow,
            DYPaletteColor.DYGreen,
            DYPaletteColor.DYMint,
            DYPaletteColor.DYSkyblue,
            DYPaletteColor.DYBlue,
            DYPaletteColor.DYPurple,
            DYPaletteColor.DYPink,
            DYPaletteColor.DYLightBrown,
            DYPaletteColor.DYBrown
        ]
    }

    var isPresetColor: Bool {
        return Self.colorPreset.contains(self)
    }

}
