//
//  MembershipManager.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/07/18.
//

import Foundation
import RxSwift

/// Member Info
struct MemberInfo {
    let deviceToken: String
    let activityType: UserActivityType
}

/// Activity Type
enum UserActivityType: Int {
    case new = 0, subscriber, expiredSubscriber
}

final class MembershipManager {
    static let shared = MembershipManager()

    var isMembership: Bool { DYUserDefaults.isMembership }

    var userActivityType: UserActivityType { UserActivityType(rawValue: DYUserDefaults.activityType) ?? .new }

    var didChangeMembershipType = BehaviorSubject<UserActivityType>(
        value: UserActivityType(rawValue: DYUserDefaults.activityType) ?? .new
    )

    /// Changed User Activity Type
    func didChangeMembership(type: UserActivityType) {
        DYUserDefaults.activityType = type.rawValue
        DYUserDefaults.isMembership = type == .subscriber ? true : false
        didChangeMembershipType.onNext(type)
    }
}
