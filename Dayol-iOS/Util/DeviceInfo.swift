//
//  DeviceInfo.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/22.
//

import UIKit

var isPadDevice: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
}

var screenWidth: CGFloat {
    UIScreen.main.bounds.width
}

var screenHeight: CGFloat {
    UIScreen.main.bounds.height
}
