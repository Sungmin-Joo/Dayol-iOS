//
//  FBLog.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/12.
//

import Firebase

enum LogType: String {
    case impression
    case click
    case error

    enum Menu: String {
        case home
        case diary
        case paper
        case sticket
    }
}

final class FBLog: Analytics {
    override class func logEvent(_ name: String, parameters: [String : Any]?) {
        self.setUserID(Config.shared.deviceToken)
        super.logEvent(name, parameters: parameters)
    }
    /// impression
    static func impression(_ key: LogType.Menu, value: String) {
        logEvent(LogType.impression.rawValue, parameters: [key.rawValue: value])
        logging(LogType.impression, value: "\([key: value])")
    }

    /// click log
    static func click(_ key: LogType.Menu, value: String) {
        logEvent(LogType.click.rawValue, parameters: [key.rawValue: value])
        logging(LogType.click, value: "\([key: value])")
    }

    /// error log
    static func error(_ key: LogType.Menu, value: String) {
        logEvent(LogType.error.rawValue, parameters: [key.rawValue: value])
        logging(LogType.error, value: "\([key: value])")
    }

    private static func logging(_ logType: LogType, value: String) {
        #if DEBUG
        print("\(Date.now) [🛫] - [\(logType)] Message: \(value)")
        #endif
        return
    }
}

enum DYLog {
    /// error log
    static func e(_ key: String, value: String) {
        #if DEBUG
        print("\(Date.now) [🧨] - [ERROR] KEY: \(key) Message: \(value)")
        #endif
        return
    }

    /// debuging log
    static func d(_ key: String, value: String) {
        #if DEBUG
        print("\(Date.now) [🔧] - [DEBUG] KEY: \(key) Message: \(value)")
        #endif
        return
    }
}
