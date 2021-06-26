//
//  Config.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/28.
//

import Foundation
import Firebase
import CoreData

enum BuildPhase {
    case beta
    case prod

    static let phase: BuildPhase = {
        #if BETA
        return .beta
        #elseif PRODUCT
        return .prod
        #endif
    }()

    var isBeta: Bool {
        self == .beta
    }

    var isProd: Bool {
        self == .prod
    }
}

enum UserActivityType {
    case new
    case comeback
    case exist
}

enum Language {
    case en, ko
}

class Config {
    static let shared: Config = Config()

    let phase = BuildPhase.phase

    var deviceToken: String {
        DYUserDefaults.deviceToken
    }

    var isMembership: Bool {
        DYUserDefaults.isMembership
    }

    var language: Language {
        let localeID = Locale.preferredLanguages.first
        let deviceLocale = (Locale(identifier: localeID!).languageCode)!
        if deviceLocale == "ko" {
            return .ko
        } else if deviceLocale == "en" {
            return .en
        } else {
            return .en
        }
    }

    func initalize() {
        FirebaseApp.configure()
        PersistentManager.shared.saveContext()
    }
}
