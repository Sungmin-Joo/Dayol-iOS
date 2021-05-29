//
//  Config.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/28.
//

import Foundation
import Firebase

class Config {
    static let shared: Config = Config()

    func initalize() {
        FirebaseApp.configure()
    }
}
