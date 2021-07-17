//
//  DeviceInfo.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/22.
//

import UIKit

enum Orientation {
    case portrait
    case landscape
    case unknown

    static var currentState: Orientation {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return .landscape
        case .portraitUpsideDown, .portrait:
            return .portrait
        default:
            return .unknown
        }
    }
}

var isIPad: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
}
let homeIPadContentSize = CGSize(width: 375, height: 667)
let homeIPadContentCornerRadius: CGFloat = 12
