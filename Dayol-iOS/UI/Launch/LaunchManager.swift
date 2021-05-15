//
//  Manager.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import Foundation
import RxSwift

final class LaunchManager {
    let showOnboarding: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)

    init() {
        showOnboarding.onNext(DYUserDefaults.shouldOnboading)
    }
}
