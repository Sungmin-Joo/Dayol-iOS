//
//  TextStyleModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import Foundation

enum TextStyleModel {

    enum Alignment: String {
        case leading, center, trailing

        var nextAlignment: Alignment {
            switch self {
            case .leading: return .center
            case .center: return .trailing
            case .trailing: return .leading
            }
        }

        var imageName: String {
            switch self {
            case .leading: return "toolBar_textStyle_align_\(rawValue)"
            case .center: return "toolBar_textStyle_align_\(rawValue)"
            case .trailing: return "toolBar_textStyle_align_\(rawValue)"
            }
        }
    }

    enum AdditionalOption: String, CaseIterable {
        case bold, cancelLine, underLine

        static let selectedImageName = "toolBar_textStyle_button_selected"

        var backgroundImageName: String {
            switch self {
            case .bold: return "toolBar_textStyle_\(rawValue)"
            case .cancelLine: return "toolBar_textStyle_\(rawValue)"
            case .underLine: return "toolBar_textStyle_\(rawValue)"
            }
        }

    }

    enum Font: CaseIterable {

        // Apple
        case sandolGodic

        // Nanum
        case godic, square

        // Custom
        case binggrae

        static var fontList: [Font] = {
            return Font.allCases
        }()

    }
}
