//
//  UIView+Extension.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/28.
//

import UIKit

extension UIView {

    func showToast(
        text: String,
        bottomMargin: CGFloat,
        configure: DYToastConfigure = DYToastConfigure.deafault
    ) {
        let toast = DYToast(configure: configure,
                            text: text,
                            numberOfLines: 2)
        toast.alpha = 0

        addSubview(toast)

        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                          constant: -bottomMargin)
        ])

        // show toast animation
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                toast.alpha = 1.0
            }, completion: { _ in
                // hide toast animation
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: configure.toastDuration,
                    options: .curveEaseInOut,
                    animations: {
                        toast.alpha = 0
                    }, completion: { _ in
                        toast.removeFromSuperview()
                    }
                )
            }
        )
    }

    func addSubViewPinEdge(_ view: UIView) {
        if view.translatesAutoresizingMaskIntoConstraints == true {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
