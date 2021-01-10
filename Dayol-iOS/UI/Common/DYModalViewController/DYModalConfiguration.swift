//
//  DYModalConfiguration.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/05.
//

import UIKit

extension DYModalConfiguration {
    enum ModalStyle {
        case custom(containerHeight: CGFloat)
        case normal
        case small

        var contentHeight: CGFloat {
            switch self {
            case .custom(let containerHeight): return containerHeight
            case .normal: return 610.0
            case .small: return 375.0
            }
        }
    }

    enum DimStyle {
        case custom(dimColor: UIColor)
        case black
        case clear

        var color: UIColor {
            switch self {
            case .custom(let dimColor): return dimColor
            case .black: return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            case .clear: return .clear
            }
        }
    }
}

struct DYModalConfiguration {
    let dimStyle: DimStyle
    let modalStyle: ModalStyle

    init(
        dimStyle: DimStyle = .black,
        modalStyle: ModalStyle = .normal
    ) {
        self.dimStyle = dimStyle
        self.modalStyle = modalStyle
    }
}
