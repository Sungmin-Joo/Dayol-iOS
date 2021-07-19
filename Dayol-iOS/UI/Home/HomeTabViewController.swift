//
//  HomeViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/09.
//

import UIKit
import RxSwift
import GoogleMobileAds

class HomeTabViewController: DYViewController {
    private let tabBarView: HomeTabBarView = {
        let view = HomeTabBarView(mode: .diary)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) var viewControllers: [HomeTabBarView.TabType: DYViewController] = [:]

    var currentTab: HomeTabBarView.TabType = .diary {
        didSet { updateCurrentChildVC() }
    }

    private lazy var gadManager: GADManager = GADManager()

    private let disposeBag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewControllers[.diary] = DiaryListViewController()
        viewControllers[.favorite] = FavoriteViewController()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayoutConstraints()
        configureFirstList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        loadAD()
    }

    func loadAD() {
        if !MembershipManager.shared.isMembership {
            self.gadManager.configureBanner(targetViewController: self, targetView: self.tabBarView)
        } else {
            self.gadManager.closeBanner()
        }
    }
}

// MARK: - Controller ChildVC

extension HomeTabViewController: HomeTabbarDelegate {
    func didTapMenu(_ type: HomeTabBarView.EventType) {
        switch type {
        case .add:
            let diaryEditViewController = DiaryEditViewController()
            let nav = DYNavigationController(rootViewController: diaryEditViewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .showList(let tab):
            self.currentTab = tab
        }
    }

    private func updateCurrentChildVC() {
        guard
            let diaryListViewController = viewControllers[.diary],
            let favoriteViewController = viewControllers[.favorite]
        else {
            return
        }

        switch currentTab {
        case .diary:
            hideContentController(favoriteViewController)
            displayContentController(diaryListViewController)
        case .favorite:
            hideContentController(diaryListViewController)
            displayContentController(favoriteViewController)
        }
    }

    private func displayContentController(_ viewController: DYViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)

        viewController.view.frame = view.frame
        viewController.didMove(toParent: self)

        view.bringSubviewToFront(tabBarView)
    }

    private func hideContentController(_ viewController: DYViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}


// MARK: - Setup UI

private extension HomeTabViewController {
    func setupViews() {
        view.addSubview(tabBarView)
        tabBarView.delegate = self
    }

    func configureFirstList() {
        let tabType: HomeTabBarView.TabType = DYUserDefaults.showFavoriteListAtLaunch ? .favorite : .diary
        currentTab = tabType
        tabBarView.currentTabMode = tabType
    }

    func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
