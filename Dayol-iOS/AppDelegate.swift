//
//  AppDelegate.swift
//  Dayol
//
//  Created by 박종상 on 2020/12/04.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = HomeViewController()
        let navigationVC = UINavigationController(rootViewController: homeViewController)

        navigationVC.isNavigationBarHidden = true
        window.rootViewController = navigationVC
        
		self.window = window
		self.window?.makeKeyAndVisible()
        
		return true
	}
}

