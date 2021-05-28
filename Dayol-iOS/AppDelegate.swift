//
//  AppDelegate.swift
//  Dayol
//
//  Created by 박종상 on 2020/12/04.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        let splashVC = LaunchViewController()
        window.rootViewController = splashVC
        
		self.window = window
		self.window?.makeKeyAndVisible()
        
		return true
	}

}

// MARK: - UIWindow Extension (TODO: MoveExtension Group)
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

