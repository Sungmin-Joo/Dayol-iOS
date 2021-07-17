//
//  Manager.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import Foundation
import Firebase
import GoogleMobileAds
import CoreData
import RxSwift

final class LaunchManager {
    enum Result {
        case beta
        case prod
    }

    var shouldOnboarding: Bool {
        set {
            DYUserDefaults.shouldOnboading = newValue
        }
        get {
            return DYUserDefaults.shouldOnboading
        }
    }

    var launchConfig: Single<Any> {
        return Single.just(true) // 약관
            .map { _ in
                FirebaseApp.initialize()
                PersistentManager.shared.saveContext()
                GADMananer.mobileAdsStart()

            }
            .flatMap { _ -> Single<API.MembershipReceiptAPI.Response> in
                return IAPManager.shared.checkPurchased()
            }
            .map { (response: API.MembershipReceiptAPI.Response) -> Result  in
                DYLog.i(.inAppPurchase, value: "[STATUS: \(response.status)]")
                DYLog.i(.inAppPurchase, value: "[ADMIN_ID\(response.receipt.adamId)]")
                return.prod
            }
    }
}
