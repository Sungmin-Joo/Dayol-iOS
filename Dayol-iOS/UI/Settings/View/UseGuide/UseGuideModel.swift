//
//  UseGuideModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/07.
//

import Foundation

private enum Text {

}

enum UseGuide {

    enum Style: String {
        case vertical = "v"
        case horizontal = "h"

        var text: String {
            return "setting_guide_content_title_\(self.rawValue)".localized
        }
    }

    enum Scene: String, CaseIterable {
        case about
        case monthly
        case weekly
        case daily
        case cornell
        case muji
        case grid
        case quartet
        case monthlyTracker = "monthlytracker"

        var thumbnailImageName: String {
            return "img_thumb_\(self.rawValue)"
        }

        var title: String {
            return "setting_guide_\(self.rawValue)".localized
        }

        func contentImageName(style: UseGuide.Style) -> String {
            if self == .about {
                return "guide_about"
            }

            let styleString = style == .horizontal ? "h" : "v"

            return "guide_\(self.rawValue)_\(styleString)"
        }
    }
}
