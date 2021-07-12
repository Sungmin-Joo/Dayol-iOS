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
    private var barColor: UIColor = Design.navigationBarBarBackgroundColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupToolbar()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if isIPad {
            return .all
        } else {
            return .portrait
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if isIPad {
            return .landscapeLeft
        } else {
            return .portrait
        }
    }

    func setupNavigationBar() {
        navigationBar.barTintColor = barColor
        navigationBar.isTranslucent = false
    }
    
    func setupToolbar() {
        isToolbarHidden = false
        toolbar.barTintColor = barColor
        toolbar.isTranslucent = false
    }
}

extension DYNavigationController {
    var navigationBarColor: UIColor {
        get {
            return self.barColor
        }
        set {
            self.barColor = newValue
            navigationBar.barTintColor = newValue
        }
    }
}
