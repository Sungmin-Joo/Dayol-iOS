//
//  PopupTransitionDelegate.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/15.
//

import UIKit

protocol PopupPresentDelegate {
    var dimmView: UIView { get set }
    var containerView: UIView { get set }
}

extension PopupPresentDelegate {

    func presentPopup(animated: Bool = true) {
        let duration: TimeInterval = animated ? 0.1 : 0
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut]
        ) {
            self.dimmView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }

    func dismissPopup(animated: Bool = true, completion: (() -> Void)? = nil) {
        let duration: TimeInterval = animated ? 0.1 : 0

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.dimmView.alpha = 0
                self.containerView.alpha = 0
            }, completion: { _ in
                completion?()
            }
        )
    }
}
