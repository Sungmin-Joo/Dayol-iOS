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
    var deviceToken: String = ""

    func initalize() {
        FirebaseApp.configure()
        FirebaseStorage.shared.loadImages()
    }
}

// MARK: - ImageStorage
extension Config {
    enum ImageStorage {
        case debug
        case real

        private var baseURL: String {
            switch self {
            case .debug: return "gs://dayol-beta.appspot.com/"
            case .real: return "gs://dayol.appspot.com/"
            }
        }
    }
}
