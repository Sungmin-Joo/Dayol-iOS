//
//  DayolUserDefaults.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import Foundation

@propertyWrapper
struct DYUserDefault<T> {
    let key: String
    let value: T

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum DYUserDefaults {
    // MARK: Type
    enum Launch: String {
        case shouldOnboarding
    }

    enum Settings: String {
        case homeListOption
    }

    // Properties
    @DYUserDefault(key: Launch.shouldOnboarding.rawValue, value: true)
    static var shouldOnboading: Bool

    @DYUserDefault(key: Settings.homeListOption.rawValue, value: false)
    static var showFavoriteListAtLaunch: Bool
}
