//
//  Config.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/28.
//

import Foundation
import Firebase
import CoreData

class Config {
    static let shared: Config = Config()
    var deviceToken: String = ""

    func initalize() {
        FirebaseApp.configure()
        PersistentManager.shared.saveContext()
    }
}
