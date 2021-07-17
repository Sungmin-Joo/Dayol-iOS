//
//  GADBanner.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/07/17.
//

import GoogleMobileAds

final class GADMananer: NSObject {
    enum Design {
        static let adBannerHeight: CGFloat = 50
    }

    static func mobileAdsStart(completionHandler: GADInitializationCompletionHandler? = nil) {
        GADMobileAds.sharedInstance().start(completionHandler: completionHandler)
    }

    private(set) lazy var gadBannerView: GADBannerView = {
        let gadBannerView = GADBannerView()
        gadBannerView.translatesAutoresizingMaskIntoConstraints = false
        gadBannerView.adUnitID = Config.shared.adUnitID
        return gadBannerView
    }()


    func configBannerAD(targetViewController: DYViewController) {
        gadBannerView.rootViewController = targetViewController
        gadBannerView.delegate = self
        loadBannerView(parentWidth: targetViewController.view.frame.width)
    }

    func loadBannerView(parentWidth: CGFloat) {
        gadBannerView.adSize = GADAdSizeFromCGSize(CGSize(width: parentWidth, height: Design.adBannerHeight))
        gadBannerView.load(GADRequest())
    }
}

// MARK: - BannerView Delegate

extension GADMananer: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {}
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {}
}
