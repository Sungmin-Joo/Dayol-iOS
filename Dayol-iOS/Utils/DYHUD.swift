//
//  DYHUD.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/07/01.
//

import UIKit

final class DYHUD {
    enum HUDType {
        case ring
    }

    private static let shared = DYHUD()

    private var window: UIWindow? { return UIApplication.shared.windows.first(where: { $0.isKeyWindow }) }
    private weak var hudView: DYHUDView?

    private func setHUDView(_ view: UIView? = nil, type: HUDType = .ring, useClearBackground: Bool = false) -> DYHUDView? {
        if let hudView = DYHUD.shared.hudView {
            hudView.backgroundColor = useClearBackground ? UIColor.clear : UIColor.black.withAlphaComponent(0.4)
            if view != nil {
                view?.addSubview(hudView)
            }
            return hudView
        }
        else {
            let hudView = DYHUDView(frame: window?.frame ?? .zero)
            hudView.backgroundColor = useClearBackground ? UIColor.clear : UIColor.black.withAlphaComponent(0.4)
            if view != nil {
                view?.addSubview(hudView)
            } else {
                window?.addSubview(hudView)
            }
            self.hudView = hudView
            return hudView
        }
    }

    // MARK: - IN TARGET VIEW

    static func show(_ view: UIView, type: HUDType = .ring, useClearBackground: Bool = false) {
        if let hudView = shared.setHUDView(view, type: type, useClearBackground: useClearBackground) {
            view.isUserInteractionEnabled = false
            hudView.start()
        }
    }

    static func hide(_ view: UIView) {
        if let hudView = shared.hudView {
            view.isUserInteractionEnabled = true
            hudView.stop()
        }
    }

    // MARK: - IN WINDOW

    static func show(_ type: HUDType = .ring, useClearBackground: Bool = false) {
        if let hudView = shared.setHUDView(type: type, useClearBackground: useClearBackground) {
            shared.window?.isUserInteractionEnabled = false
            hudView.start()
        }
    }

    static func hide() {
        if let hudView = shared.hudView {
            shared.window?.isUserInteractionEnabled = true
            hudView.stop()
        }
    }
}

// MARK: - ACTUAL LOADING VIEW CLASS

private class DYHUDView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = isPadDevice ? .large : .medium
        return indicator
    }()

    var isAnimating: Bool {
        get { return activityIndicator.isAnimating }
    }

    var indicatorStyle: UIActivityIndicatorView.Style {
        get { return activityIndicator.style }
        set { activityIndicator.style = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func addSubviews() {
        addSubview(activityIndicator)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func start() {
        activityIndicator.startAnimating()

        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }

    func stop() {
        activityIndicator.stopAnimating()

        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        }
    }
}

