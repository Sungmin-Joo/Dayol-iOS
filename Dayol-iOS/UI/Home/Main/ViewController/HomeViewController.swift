//
//  HomeViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/09.
//

import UIKit
import RxSwift

private enum Design {
    static let iPadContentSize = CGSize(width: 375, height: 667)
    static let iPadContentCornerRadius: CGFloat = 12
}

class HomeViewController: DYViewController {

    private let diaryListVC: DiaryListViewController = {
        let vc = DiaryListViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    private let favoriteVC: FavoriteViewController = {
        let vc = FavoriteViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    private let tabBarView: HomeTabBarView = {
        let view = HomeTabBarView(mode: .diary)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let disposeBag = DisposeBag()
    var currentTab: HomeTabBarView.TabType = .diary {
        didSet {
            updateCurrentChildVC()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayoutConstraints()
        bindEvent()
        configureFirstList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
    }
}

// MARK: - Event
extension HomeViewController {
    private func bindEvent() {
        tabBarView.buttonEvent.subscribe(onNext: { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .showList(let tab):
                self.currentTab = tab
            case .add:
                let diaryEditViewController = DiaryEditViewController()
                let nav = DYNavigationController(rootViewController: diaryEditViewController)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        })
        .disposed(by: disposeBag)

        diaryListVC.iconButton.rx.tap
            .bind { [weak self] in
                self?.presentSettingVC()
            }
            .disposed(by: disposeBag)

        favoriteVC.iconButton.rx.tap
            .bind { [weak self] in
                self?.presentSettingVC()
            }
            .disposed(by: disposeBag)
    }

    private func presentSettingVC() {
        let settingVC = SettingsViewController()
        let nav = DYNavigationController(rootViewController: settingVC)
        nav.modalPresentationStyle = isPadDevice ? .formSheet : .fullScreen

        if isPadDevice {
            nav.preferredContentSize = Design.iPadContentSize
            nav.view.layer.cornerRadius = Design.iPadContentCornerRadius
        }

        present(nav, animated: true)
    }
}

// MARK: - Controller ChildVC
extension HomeViewController {

    private func updateCurrentChildVC() {
        guard currentTab == .diary else {
            hideContentController(content: diaryListVC)
            displayContentController(content: favoriteVC)
            return
        }
        hideContentController(content: favoriteVC)
        displayContentController(content: diaryListVC)
    }

    private func displayContentController(content: DYViewController) {
        addChild(content)
        view.addSubview(content.view)

        NSLayoutConstraint.activate([
            content.view.topAnchor.constraint(equalTo: view.topAnchor),
            content.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        content.didMove(toParent: self)
        view.bringSubviewToFront(tabBarView)
    }

    private func hideContentController(content: DYViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }

}


// MARK: - Setup UI
extension HomeViewController {

    private func setupViews() {
        view.addSubview(tabBarView)
    }

    private func configureFirstList() {
        if DYUserDefaults.showFavoriteListAtLaunch {
            currentTab = .favorite
            tabBarView.currentTabMode = .favorite
        }
    }
}

// MARK: - Layout Constraints
extension HomeViewController {

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
