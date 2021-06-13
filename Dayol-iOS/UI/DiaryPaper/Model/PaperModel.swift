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

enum PaperOrientationConstant {
    static let maximumZoomIn: CGFloat = 3.0

    static func size(orentantion: Paper.PaperOrientation) -> CGSize {
        switch orentantion {
        case .portrait: return CGSize(width: 614.0, height: 917.0)
        case .landscape: return CGSize(width: 1024.0, height: 662.0)
        }
    }

    static func contentStackViewInset(orientation: Paper.PaperOrientation, scrollViewSize: CGSize) -> UIEdgeInsets {
        let scrollWidth = scrollViewSize.width
        let paperWidth = size(orentantion: orientation).width
        let gap = (scrollWidth - paperWidth) / 2
        return UIEdgeInsets(top: 0, left: gap, bottom: 20, right: gap)
    }

    static func minimumZoomOut(orientation: Paper.PaperOrientation, scrollViewSize: CGSize) -> CGFloat {
        let paperSize = size(orentantion: orientation)
        switch orientation {
        case .landscape:
            return scrollViewSize.width / paperSize.width
        case .portrait:
            return scrollViewSize.height / paperSize.height
        }
    }
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
