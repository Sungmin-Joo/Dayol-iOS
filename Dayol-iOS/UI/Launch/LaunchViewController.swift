//
//  SplashViewController.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import UIKit
import RxSwift

private enum Design {
    static let logoImage = UIImage(named: "splash_logo")
    static let labelImage = UIImage(named: "splash_label")
}

final class LaunchViewController: DYViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.image = Design.logoImage
        return imageView
    }()

    private let labelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Design.labelImage
        return imageView
    }()

    private lazy var onboadingView: OnboadingView = {
        let onboadingView = OnboadingView()
        onboadingView.translatesAutoresizingMaskIntoConstraints = false
        onboadingView.alpha = 0
        onboadingView.isHidden = true
        return onboadingView
    }()

    private let splashManager = LaunchManager()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLunchScreen()
        bind()
    }

    private func configureLunchScreen() {
        view.backgroundColor = UIColor.splashBackground
        view.addSubview(logoImageView)
        view.addSubview(labelImageView)
        configureConstraints()
    }

    private func bind() {
        // TODO: 온보딩 뷰 안에서 뷰컨 스위칭하는것도 체크해서 델리게이트로 빼야함.
        splashManager.onboardingObserver
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard
                    let self = self,
                    let shouldOnboading = result.element,
                    shouldOnboading
                else {
                    let homeViewController = HomeViewController()
                    let navigationController = DYNavigationController(rootViewController: homeViewController)
                    navigationController.isNavigationBarHidden = true

                    AppDelegate.shared?.window?.switchRootViewController(navigationController)
                    return
                }

                self.view.addSubview(self.onboadingView)
                self.configureOnboadingConstraints()

                self.view.layoutIfNeeded()
                self.onboadingView.configureOnboard()

                UIView.animate(withDuration: 0.3) {
                    self.logoImageView.isHidden = true
                    self.labelImageView.isHidden = true
                    self.onboadingView.isHidden = false
                    self.onboadingView.alpha = 1.0
                }
                DYUserDefaults.shouldOnboading = !shouldOnboading
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Set Constraints

private extension LaunchViewController {
    func configureConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            labelImageView.widthAnchor.constraint(equalToConstant: 129),
            labelImageView.heightAnchor.constraint(equalToConstant: 17),
            labelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30)
        ])
    }

    func configureOnboadingConstraints() {
        NSLayoutConstraint.activate([
            onboadingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
