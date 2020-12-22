//
//  UIDevice+Extension.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/22.
//

import UIKit

extension UIDevice {

    static var isPadDevice: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

}
