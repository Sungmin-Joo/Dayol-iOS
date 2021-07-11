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
        configure()
		return true
	}

    private func configure() {
        let window = UIWindow()
        let splashVC = LaunchViewController()
        window.rootViewController = splashVC
        window.overrideUserInterfaceStyle = .light // TODO: if Apply DarkMode Remove

        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        DYUserDefaults.deviceToken = deviceToken.map { String(format: "%02x", $0) }.joined()
    }
}
