//
//  DYModalViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/05.
//

import UIKit

extension UIViewController {
    func presentCustomModal(_ viewController: DYModalViewController, completion: (() -> Void)? = nil) {
        present(viewController, animated: false, completion: completion)
    }
}

private enum Design {
    static let cornerRadius: CGFloat = 15.0
    static let headerAreaHeight: CGFloat = 56.0
    static let defaultBGColor = UIColor.white
}

class DYModalViewController: UIViewController {

    private var lastMoved: CGFloat = .greatestFiniteMagnitude

    // MARK: - DYModalConfiguration

    private let configure: DYModalConfiguration
    var containerViewHeight: CGFloat {
        if configure.modalStyle.contentHeight > view.bounds.height {
            return view.bounds.height
        }

        return configure.modalStyle.contentHeight
    }
    var dimColor: UIColor {
        configure.dimStyle.color
    }

    // MARK: - Default Private UI

    private var contentViewBottomConstraint = NSLayoutConstraint()
    private let dimView = UIView()
    private let containerView = UIView()
    private let headerArea = UIView()
    private let contentArea = UIView()

    // MARK: - Custom  Public UI

    var titleView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            setTitleView()
        }
    }

    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            setContentView()
        }
    }

    // MARK: - Error for develop CustomModalViewController

    override var modalTransitionStyle: UIModalTransitionStyle {
        didSet {
            fatalError("do not change CustomModalViewController modalTransitionStyle")
        }
    }
    override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            fatalError("do not change CustomModalViewController modalPresentationStyle")
        }
    }

    // MARK: - Init

    convenience init() {
        let defualtConfigure = DYModalConfiguration()
        self.init(configure: defualtConfigure)
    }

    init(configure: DYModalConfiguration) {
        self.configure = configure
        super.init(nibName: nil, bundle: nil)
        super.modalTransitionStyle = .crossDissolve
        super.modalPresentationStyle = .overCurrentContext

        setupSubviews()
        setupConstraints()
        setupGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentContentView(animated: animated)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissContentView(animated: flag) {
            super.dismiss(animated: false, completion: completion)
        }
    }

}

// MARK: - Modal Animation

extension DYModalViewController {

    private func presentContentView(animated: Bool) {
        // 이 전까지 적용된 constraint를 선 반영 후 present 시작
        view.layoutIfNeeded()

        let animationBlock = { [weak self] in
            self?.dimView.alpha = 1
            self?.contentViewBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }

        guard animated else {
            animationBlock()
            return
        }

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut, .preferredFramesPerSecond60]
        ) {
            animationBlock()
        }
    }

    private func dismissContentView(animated: Bool, completion: (() -> Void)? = nil) {
        let animationBlock = { [weak self] in
            guard let self = self else { return }
            self.dimView.alpha = 0
            self.contentViewBottomConstraint.constant = self.containerViewHeight
            self.view.layoutIfNeeded()
        }

        guard animated else {
            animationBlock()
            completion?()
            return
        }

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut]
        ) {
            animationBlock()
        } completion: { _ in
            completion?()
        }
    }

}

// MARK: - Gesture

extension DYModalViewController {

    @objc func didTap(recog: UIGestureRecognizer) {
        dismiss(animated: true)
    }

    @objc func didPan(recog: UIPanGestureRecognizer) {
        switch recog.state {
        case .changed:
            panningContentView(recog)
        case .ended, .cancelled, .failed:
            finnishPanning(recog)
        default: break
        }
    }

    private func panningContentView(_ recog: UIPanGestureRecognizer) {
        let location = recog.translation(in: containerView)
        if lastMoved < .greatestFiniteMagnitude {
            let bottomMargin = contentViewBottomConstraint.constant - (lastMoved - location.y)
            lastMoved = location.y
            updateContentViewBottomMargin(bottomMargin)
        } else {
            lastMoved = location.y
        }
    }

    private func finnishPanning(_ recog: UIPanGestureRecognizer) {

        defer {
            lastMoved = .greatestFiniteMagnitude
        }

        let velocity = recog.velocity(in: recog.view)
        let threshold: CGFloat = 80

        let isFastVelocity = (velocity.y > threshold && contentViewBottomConstraint.constant > threshold)
        let isLowHeight = (velocity.y > 0 && contentViewBottomConstraint.constant > containerViewHeight / 3)
        let isEndPhase = recog.state == .ended
        
        if isEndPhase && (isFastVelocity || isLowHeight) {
            dismiss(animated: true)
            return
        }

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut, .preferredFramesPerSecond60]
        ) {
            self.updateContentViewBottomMargin(0)
            self.view.layoutIfNeeded()
        }
    }

    private func updateContentViewBottomMargin(_ bottomMargin: CGFloat) {
        let calcedMargin = bottomMargin < 0 ? 0 : bottomMargin
        contentViewBottomConstraint.constant = calcedMargin
    }

}

// MARK: - Set Content

extension DYModalViewController {

    private func setTitleView() {
        guard let titleView = titleView else { return }

        titleView.translatesAutoresizingMaskIntoConstraints = false
        headerArea.addSubview(titleView)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: headerArea.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: headerArea.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: headerArea.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: headerArea.bottomAnchor)
        ])
    }

    private func setContentView() {
        guard let contentView = contentView else { return }

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentArea.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentArea.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor)
        ])
    }

}

// MARK: - Setup

extension DYModalViewController {

    private func setupSubviews() {
        dimView.alpha = 0
        dimView.backgroundColor = dimColor
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)

        containerView.backgroundColor = Design.defaultBGColor
        containerView.layer.cornerRadius = Design.cornerRadius
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        headerArea.translatesAutoresizingMaskIntoConstraints = false
        contentArea.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerArea)
        containerView.addSubview(contentArea)
    }

    private func setupConstraints() {
        contentViewBottomConstraint = NSLayoutConstraint(item: containerView,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: containerViewHeight)

        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: dimView.bottomAnchor, constant: -Design.cornerRadius),
            containerView.leadingAnchor.constraint(equalTo: dimView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: dimView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerViewHeight),
            contentViewBottomConstraint,

            headerArea.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerArea.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerArea.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerArea.heightAnchor.constraint(equalToConstant: Design.headerAreaHeight),

            contentArea.topAnchor.constraint(equalTo: headerArea.bottomAnchor),
            contentArea.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentArea.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentArea.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTap(recog:)))
        dimView.addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(didPan(recog:)))
        containerView.addGestureRecognizer(panGestureRecognizer)
    }

}
