//
//  FavoriteViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/17.
//

import UIKit
import RxSwift

private enum Design {
    static let topIcon = Assets.Image.Home.topIcon
    static let bgColor = UIColor.white
}

class FavoriteViewController: DYViewController {
    lazy var logoIconButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.topIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap.bind { [weak self] in
            guard let tabViewController = AppDelegate.shared?.rootViewController else { return }
            let settingVC = SettingsViewController()
            let nav = DYNavigationController(rootViewController: settingVC)
            nav.modalPresentationStyle = isIPad ? .formSheet : .fullScreen

            if isIPad {
                nav.preferredContentSize = homeIPadContentSize
                nav.view.layer.cornerRadius = homeIPadContentCornerRadius
            }

            tabViewController.present(nav, animated: true)
        }
        .disposed(by: disposeBag)
        return button
    }()

    private let emptyView: HomeEmptyView = {
        let view = HomeEmptyView(style: .favorite)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var isEmpty: Bool = true {
        didSet {
            updateCurrentState()
        }
    }

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayoutConstraints()
        updateCurrentState()
    }

    private func updateCurrentState() {
        emptyView.isHidden = !isEmpty
    }
}

// MARK: - Setup UI
extension FavoriteViewController {
    private func setupViews() {
        view.addSubview(logoIconButton)
        view.addSubview(emptyView)
        view.backgroundColor = Design.bgColor
    }
}

// MARK: - Layout Constraints
extension FavoriteViewController {

    private func setupLayoutConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            logoIconButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            logoIconButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),

            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
