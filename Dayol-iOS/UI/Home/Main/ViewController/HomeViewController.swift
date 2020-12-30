//
//  HomeViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/09.
//

import RxSwift

private enum Design {
    // Some Const
}

class HomeViewController: UIViewController {

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
                self.present(nav, animated: true, completion: nil)
            }
        })
        .disposed(by: disposeBag)
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

    private func displayContentController(content: UIViewController) {
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

    private func hideContentController(content: UIViewController) {
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
