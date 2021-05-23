//
//  Manager.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import Foundation
import RxSwift

final class LaunchManager {
    let onboardingObserver: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)

    init() {
        onboardingObserver.onNext(DYUserDefaults.shouldOnboading)
    }
}
