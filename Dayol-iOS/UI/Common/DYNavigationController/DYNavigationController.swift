//
//  DYNavigationController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/29.
//

import UIKit
import RxSwift
import RxCocoa

enum NavigationToolBarType {
    case funtion
    case draw
}

private enum Design {
    static let navigationBarBarBackgroundColor: UIColor = .white
    static let navigationToolBarBackgroundColor: UIColor = .white
}

class DYNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setToolbar()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if isPadDevice {
            return .all
        } else {
            return .portrait
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if isPadDevice {
            return .landscapeLeft
        } else {
            return .portrait
        }
    }

    func setNavigationBar() {
        navigationBar.barTintColor = Design.navigationBarBarBackgroundColor
        navigationBar.isTranslucent = false
    }
    
    func setToolbar() {
        isToolbarHidden = false
        toolbar.barTintColor = Design.navigationToolBarBackgroundColor
        toolbar.isTranslucent = false
    }
}
