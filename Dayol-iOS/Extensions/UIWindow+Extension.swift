//
//  UIWindow+Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/28.
//

import UIKit

extension UIWindow {
    func switchRootViewController(
        _ viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.35,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        completionHandler: (() -> Void)? = nil
    ) {
        guard animated else {
            rootViewController = viewController
            return
        }

        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completionHandler?()
        }
    }
}

