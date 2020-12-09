//
//  Assets.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/09.
//

import UIKit

enum Assets {

    enum Home {

        case pageIcon

        var image: UIImage? {
            switch self {
            case .pageIcon:
                return UIImage(named: "icon_home_dayol")
            }
        }
    }
}
