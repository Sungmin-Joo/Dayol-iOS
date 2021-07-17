//
//  Config.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/28.
//

import Foundation

/// Activity Type
enum UserActivityType: Int {
    case new = 0, subscriber, expiredSubscriber
}

/// Member Info
struct MemberInfo {
    let deviceToken: String
    let activityType: UserActivityType
}

class Config {
    /// Common Error
    enum InternalError: Error {
        case notProduct
    }

    /// Build Phase
    enum BuildPhase {
        case beta, prod

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

    /// Language
    enum Language {
        case en, ko
    }

    static let shared: Config = Config()

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

    var inAppPurchaseURL: String {
        if isProd {
            return "https://sandbox.itunes.apple.com/verifyReceipt"
        } else {
            return "https://sandbox.itunes.apple.com/verifyReceipt"
        }
    }

    var adUnitID: String {
        return "ca-app-pub-3940256099942544/2934735716" // sample id
    }
}

// MARK: - Phase

extension Config {
    var isBeta: Bool {
        BuildPhase.phase.isBeta
    }

    var isProd: Bool {
        BuildPhase.phase.isProd
    }
}
