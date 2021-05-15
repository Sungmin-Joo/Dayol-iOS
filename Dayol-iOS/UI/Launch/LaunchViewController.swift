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

final class LaunchViewController: UIViewController {
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
        splashManager.showOnboarding
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let shouldOnboading = result.element, !shouldOnboading else { return }
                UIView.animate(withDuration: 2) {
                    self?.logoImageView.isHidden = true
                    self?.labelImageView.isHidden = true
                }
//                DYUserDefaults.shouldOnboading = !shouldOnboading
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
}
